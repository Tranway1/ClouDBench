from google.cloud import bigquery
import os
import argparse
import json
from datetime import datetime
import time
import csv
import re
import asyncio

# Construct a BigQuery client object.
client = bigquery.Client()

def setup():
    with open("make_schemas.sql", "r") as f:
        query = f.read()

    query_job = client.query(query)
    results = query_job.result()
    for row in results:
            print("{} : {} views".format(row.url, row.view_count))
            

    job_config = bigquery.LoadJobConfig(
        write_disposition=bigquery.WriteDisposition.WRITE_APPEND,
        source_format=bigquery.SourceFormat.CSV, 
        schema_update_options = [bigquery.SchemaUpdateOption.ALLOW_FIELD_RELAXATION]
    )

    for _, _, files in os.walk("/Users/sabi/SoftwareDev/meng/dsg/DSGen-software-code-3.2.0rc1/data/csv"):
        for file in files:
            with open("/Users/sabi/SoftwareDev/meng/dsg/DSGen-software-code-3.2.0rc1/data/csv/" + file, "rb") as source_file:
                table_id = 'dbgroup.tpcds_1.' + file[:-4]

                load_job = client.load_table_from_file(source_file, table_id, job_config=job_config)

                load_job.result() 
                destination_table = client.get_table(table_id)  # Make an API request.
                print(f"Loaded {destination_table.num_rows} rows to {table_id}.")

async def async_query(client, query, ind, original_query_id):    
    start_time = time.time()                                   
    job = client.query(query)                                                                        
    task = asyncio.create_task(coroutine_job(job)) 
    end_time = await task 
    global runtime_info
    runtime_info[ind] = {'Query ID': original_query_id, 'Runtime': end_time - start_time}                                                                                                                                          
                                                                                                 
async def coroutine_job(job):   
    while True:
        query_job = client.get_job(job.job_id, location=job.location)  # Make an API request.
        if query_job.state == 'DONE':
            break
        await asyncio.sleep(.1)                                                                                 
    return time.time()

def execute_query(query, ind, last_timestamp):
    # Extract the id, timestamp, and SQL query
    original_query_id = query['id']
    timestamp = datetime.fromisoformat(query['start_time'])
    offset_timestamp = (timestamp - last_timestamp).total_seconds()
    # set the offset to 0 if it is negative
    if offset_timestamp < 0:
        offset_timestamp = 0

    # shrink the query waiting time by 10000.
    offset_timestamp = offset_timestamp / 10000

    # Extract the SQL query from the "text" field
    sql_query = query['text'].split('*/', 1)[1].strip()

    # Kick off the query to Redshift at the corresponding timestamp

    # Execute the query using the Redshift Data API client
    table_names = {'customer_address', 'customer_demographics', 'date_dim', 'call_center', 'catalog_page', 'income_band', 'household_demographics', 'household_demographics,', 
                            'customer','item','promotion','reason','ship_mode','store','time_dim','store_returns','store_sales','warehouse','catalog_returns','catalog_sales','inventory','web_page',
                            'web_returns', 'web_site', 'web_sales', 'catalog_returns_2'}

    pattern = r'(\bFROM\s+|\bJOIN\s+|\bUPDATE\s+|\bINTO\s+|\bWHERE\s+)(\w+(?:\.\w+)?(?:\s*,\s*\w+(?:\.\w+)?)*)'
    prefix = 'tpcds_1.'
    
    def add_prefix(match):
        if match.group():
            keyword = match.group(1)
            tables = match.group(2).split(',')
            modified_tables = [f'{prefix}{table.strip()}' if table.strip() in table_names else table.strip() for table in tables]
            return f'{keyword}{", ".join(modified_tables)}'
    
    sql_query = re.sub(pattern, add_prefix, sql_query, flags=re.IGNORECASE)
    time.sleep(offset_timestamp)

    asyncio.run(async_query(client, sql_query, ind, original_query_id))

def execute_queries(input_file):
    # Read the JSON file
    with open(input_file) as file:
        data = json.load(file)

    # Sort the queries by their timestamp
    data['queries'].sort(key=lambda query: query['start_time'])

    # Get the timestamp in the dataset from the last query
    last_timestamp = datetime.fromisoformat(data['queries'][0]['start_time'])

    # Create a list to store the runtime information
    global runtime_info
    runtime_info = [0]*len(data['queries'])

    # Iterate over the queries
    ind = 0
    for query in data['queries']:
        execute_query(query, ind, last_timestamp)
        last_timestamp = datetime.fromisoformat(data['queries'][max(ind - 1,0)]['start_time'])
        ind += 1
        print(ind)

    # Write the runtime information to a CSV file
    output_file = f"{input_file[:-5]}_bigQuery_runtime.csv"
    with open(output_file, 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['Query ID', 'Runtime'])
        writer.writeheader()
        writer.writerows(runtime_info)

    print(f"Runtime information has been written to {output_file}.")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-file', default='/Users/sabi/SoftwareDev/meng/dsg/ClouDBench/workload/amazon/traces/TPCDS_one_hour.json',
                        help='Path to the input JSON file')
    args = parser.parse_args()

    execute_queries(args.input_file)

if __name__ == '__main__':
    # setup()
    main()