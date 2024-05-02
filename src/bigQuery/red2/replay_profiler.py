from google.cloud import bigquery
import os
import argparse
import json
from datetime import datetime
import time
import csv
import re
import asyncio
import pandas as pd
import logging
logging.basicConfig(filename='errors.log', level=logging.DEBUG, filemode='w', format='%(asctime)s - %(levelname)s - %(message)s')

# Construct a BigQuery client object.
client = bigquery.Client()
TABLES = ["region", "nation", "customer", "orders", "lineitem", "partsupp", "supplier", "part"]
SFS = [1, 3, 10, 30, 100, 300, 1000, 3000]
TABLE_NAMES = set(t + '_' + str(s) for t in TABLES for s in SFS) | set(t + '_' + 'copy_' + str(s) for t in TABLES for s in range(650))

async def run_query(sql_query, ind, og_ind, original_query_id):
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
    runtime_info[ind] = {'Job ID': job.job_id, 'Original Query ID': original_query_id, 'Query Index': og_ind, 'Runtime': job.ended - job.started,'ResultRows': job.result().total_rows, 'Status': job.state, 'Created At': job.created, 'Bytes Processed': job.estimated_bytes_processed, 'Resource Usage': job.reservation_usage, 'Slot Millis': job.slot_millis} 
    print(f'Query ID: {original_query_id}, Runtime: {job.ended - job.started}')   
    

def execute_query(query, ind, og_ind, id, last_timestamp, timestamp):
    # Extract the id, timestamp, and SQL query
    offset_timestamp = (timestamp - last_timestamp).total_seconds()
    # set the offset to 0 if it is negative
    if offset_timestamp < 0:
        offset_timestamp = 0

    # Kick off the query to BigQuery at the corresponding timestamp
    time.sleep(offset_timestamp)
    original_query_id = id
    
    asyncio.run(run_query(query, ind, og_ind, original_query_id))

def execute_queries(input_file, output_file):
    # Sort the queries by their timestamp
    data = pd.read_csv(input_file)
    # pd.to_datetime()
    data.sort_values(by='starttime', ascending=True, inplace=True)

    # Get the timestamp in the dataset from the last query
    last_timestamp = datetime.fromisoformat(data.values[0][2])

    # Create a list to store the runtime information
    global runtime_info
    runtime_info = [0]*(data.shape[0])

    # Iterate over the queries
    ind = 0
    for og_ind, row in data.iterrows():
        timestamp = datetime.fromisoformat(row['starttime'])
        execute_query(row['sql'], ind, og_ind, row['query'], last_timestamp, timestamp)
        last_timestamp = timestamp       
        print(ind)
        ind += 1

    # Write the runtime information to a CSV file
    with open(output_file, 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['Job ID', 'Original Query ID', 'Query Index', 'Runtime', 'ResultRows', 'Status', 'Created At', 'Bytes Processed', 'Resource Usage', 'Slot Millis'])
        writer.writeheader()
        writer.writerows(runtime_info)

    print(f"Runtime information has been written to {output_file}.")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-file', default='../../../workload/amazon/traces/red2/bigQuery/c2_with_queries.csv',
                        help='Path to the input CSV file')
    parser.add_argument('--result-file', default='../../../results/red2/google/bigQuery_runtime_replay.csv',
                        help='Path to the output CSV file')
    args = parser.parse_args()
    execute_queries(args.input_file, args.result_file)

if __name__ == '__main__':
    main()