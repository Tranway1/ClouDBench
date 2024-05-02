from google.cloud import bigquery
import os
import argparse
import json
import csv
import asyncio
import logging
logging.basicConfig(filename='errors.log', level=logging.DEBUG, filemode='w', format='%(asctime)s - %(levelname)s - %(message)s')

'''
Profiles red1 workload by initiating queries asynchorously as soon as possible 
Logs client side runtimes
'''

# Construct a BigQuery client object.
client = bigquery.Client()

async def run_query(sql_query, ind, original_query_id):
    job = client.query(sql_query)    
    done = False
    def async_query(job):
        nonlocal done
        done = True
        if job.error_result:
            logging.debug(original_query_id)
            logging.debug(job.error_result)

    job.add_done_callback(async_query)   
    while not done:
        await asyncio.sleep(.01)

    global runtime_info
    runtime_info[ind] = {'Query ID': original_query_id, 'Runtime': job.ended - job.started}  
    print(f'Query ID: {original_query_id}, Runtime: {job.ended - job.started}')   

def execute_query(query, ind):
    # Extract the id
    original_query_id = query['id']
    
    # Extract the SQL query from the "text" field
    sql_query = query['text']

    asyncio.run(run_query(sql_query, ind, original_query_id))

def execute_queries(input_file, result_file):
    # Read the JSON file
    with open(input_file) as file:
        data = json.load(file)

    # Sort the queries by their timestamp
    data['queries'].sort(key=lambda query: query['start_time'])

    # Create a list to store the runtime information
    global runtime_info
    runtime_info = [0]*len(data['queries'])

    # Iterate over the queries
    ind = 0
    for query in data['queries']:
        execute_query(query, ind)
        ind += 1
        print(ind)

    # Write the runtime information to a CSV file
    output_file = result_file
    with open(output_file, 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['Query ID', 'Runtime'])
        writer.writeheader()
        writer.writerows(runtime_info)

    print(f"Runtime information has been written to {output_file}.")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-file', default='../../../workload/amazon/traces/red1/bigQuery/TPCDS_one_hour.json',
                        help='Path to the input JSON file')
    parser.add_argument('--result-file', default='../../../results/red1/google/TPCDS_one_hour_bigQuery_runtime_async.csv',
                        help='Path to the output CSV file')
    args = parser.parse_args()

    execute_queries(args.input_file, args.result_file)

if __name__ == '__main__':
    main()