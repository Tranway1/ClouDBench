from google.cloud import bigquery
import os
import re
import argparse
import json

'''
upload_db() for uploading locally generated TPC-DS dtaset to BigQuery
fix_queries() takes queries supplied for RedShift and coverts them to BigQuery format
'''

# Construct a BigQuery client object.
client = bigquery.Client()

def fix_queries(input_file):
    # Constants
    table_names = {'customer_address', 'customer_demographics', 'date_dim', 'call_center', 'catalog_page', 'income_band', 'household_demographics', 'household_demographics,', 
                            'customer','item','promotion','reason','ship_mode','store','time_dim','store_returns','store_sales','warehouse','catalog_returns','catalog_sales','inventory','web_page',
                            'web_returns', 'web_site', 'web_sales', 'catalog_returns_2'}
    pattern = r'(\bFROM\s+|\bJOIN\s+|\bUPDATE\s+|\bINTO\s+|\bWHERE\s+)(\w+(?:\.\w+)?(?:\s*,\s*\w+(?:\.\w+)?)*)'
    prefix = 'tpcds_1.'
    
    # Read the JSON file
    with open(input_file) as file:
        data = json.load(file)

    # Sort the queries by their timestamp
    data['queries'].sort(key=lambda query: query['start_time'])

    for i,query in enumerate(data['queries']):
        sql_query = query['text'].split('*/', 1)[1].strip()
    
        def add_prefix(match):
            if match.group():
                keyword = match.group(1)
                tables = match.group(2).split(',')
                modified_tables = [f'{prefix}{table.strip()}' if table.strip() in table_names else table.strip() for table in tables]
                return f'{keyword}{", ".join(modified_tables)}'
            
        sql_query = re.sub(pattern, add_prefix, sql_query, flags=re.IGNORECASE)
        data['queries'][i]['text'] = sql_query

    with open(input_file.split('/')[-1], "w") as outfile:
        json.dump(data, outfile)

def upload_db(input_dir):
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

    for _, _, files in os.walk(input_dir):
        for file in files:
            with open(input_dir + '/' + file, "rb") as source_file:
                table_id = 'dbgroup.tpcds_1.' + file[:-4]

                load_job = client.load_table_from_file(source_file, table_id, job_config=job_config)

                load_job.result() 
                destination_table = client.get_table(table_id)  # Make an API request.
                print(f"Loaded {destination_table.num_rows} rows to {table_id}.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--queries', default='../../../workload/amazon/traces/red1/original/TPCDS_three_hours.json',
                        help='Path to the input JSON file')
    parser.add_argument('--input-dir', default='',
                        help='Path to the input CSVs')
    args = parser.parse_args()

    # fix_queries(args.queries)
    # upload_db(args.input_dir)   # necessary when tables aren't set up yet