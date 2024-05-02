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
logging.basicConfig(filename='errors.log', level=logging.INFO, filemode='w', format='%(asctime)s - %(levelname)s - %(message)s')

'''
Profiles red2 workload by initiating queries asynchorously as soon as possible 
Logs client side runtimes
'''

# Construct a BigQuery client object.
client = bigquery.Client()
TABLES = ["region", "nation", "customer", "orders", "lineitem", "partsupp", "supplier", "part"]
SFS = [1, 3, 10, 30, 100, 300, 1000, 3000]
TABLE_NAMES = set(t + '_' + str(s) for t in TABLES for s in SFS) | set(t + '_' + 'copy_' + str(s) for t in TABLES for s in range(602))

async def run_query(sql_query, ind, original_query_id):
    job = client.query(sql_query)    
    done = False
    def async_query(job):
        nonlocal done
        done = True
        if job.error_result:
            logging.info(original_query_id)
            logging.info(job.error_result)

    job.add_done_callback(async_query)   
    while not done:
        await asyncio.sleep(.1)
    global runtime_info
    runtime_info[ind] = {'Query ID': original_query_id, 'Runtime': job.ended - job.started} 
    print(f'Query ID: {original_query_id}, Runtime: {job.ended - job.started}')   
    
def execute_query(sql_query, ind, id):
    # Extract the id, timestamp, and SQL query
    original_query_id = id
    asyncio.run(run_query(sql_query, ind, original_query_id))

def execute_queries(input_file, output_file):
    data = pd.read_csv(input_file)
    data.sort_values(by=['starttime'])

    # Create a list to store the runtime information
    global runtime_info
    runtime_info = [0]*(data.shape[0])

    # Iterate over the queries
    for ind, row in data.iterrows():
        execute_query(row['sql'], ind, row['query'])
        print(ind)

    # Write the runtime information to a CSV file
    with open(output_file, 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['Query ID', 'Runtime'])
        writer.writeheader()
        writer.writerows(runtime_info)

    print(f"Runtime information has been written to {output_file}.")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-file', default='../../../workload/amazon/traces/red2/bigQuery/c2_with_queries.csv',
                        help='Path to the input CSV file')
    parser.add_argument('--result-file', default='../../../results/red2/google/bigQuery_runtime_async.csv',
                        help='Path to the output CSV file')
    args = parser.parse_args()

    execute_queries(args.input_file, args.result_file)