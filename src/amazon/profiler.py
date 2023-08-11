import json
import time
from datetime import datetime
import boto3
import csv
import argparse

REDSHIFT_WORKGROUP_NAME = "arn:aws:redshift-serverless:us-east-1:126474391297:workgroup/350fb43c-052c-449b-81d1-4a469d8e072f"
REDSHIFT_DATABASE_NAME = "aws-workload"

def execute_query(query, earliest_timestamp):
    # Extract the id, timestamp, and SQL query
    original_query_id = query['id']
    timestamp = datetime.fromisoformat(query['start_time'])
    offset_timestamp = (timestamp - earliest_timestamp).total_seconds()
    # set the offset to 0 if it is negative
    if offset_timestamp < 0:
        offset_timestamp = 0

    # shrink the query waiting time by 10000.
    offset_timestamp = offset_timestamp / 10000

    # Extract the SQL query from the "text" field
    sql_query = query['text'].split('*/', 1)[1].strip()

    # Kick off the query to Redshift at the corresponding timestamp
    time.sleep(offset_timestamp)
    start_time = time.time()

    # Execute the query using the Redshift Data API client
    client = boto3.client('redshift-data')
    response = client.execute_statement(
        Database=REDSHIFT_DATABASE_NAME,
        WorkgroupName=REDSHIFT_WORKGROUP_NAME,
        Sql=sql_query
    )

    # Wait for the query to complete
    while True:
        status_description = client.describe_statement(Id=response['Id'])
        query_status = status_description['Status']
        # Print the original query ID and the query status
        print(f"{original_query_id}: {query_status}")
        if query_status == 'FAILED':
            raise Exception('SQL query failed:' + response['Id'] + ": " + status_description["Error"])
        elif query_status == 'FINISHED':
            break
        time.sleep(1)

    end_time = time.time()

    # Profile the runtime
    runtime = end_time - start_time
    return {'Query ID': original_query_id, 'Runtime': runtime}

def execute_queries(input_file):
    # Read the JSON file
    with open(input_file) as file:
        data = json.load(file)

    # Sort the queries by their timestamp
    data['queries'].sort(key=lambda query: query['start_time'])

    for query in data['queries']:
        print(f"{query['id']}: {query['start_time']}")


    # Get the earliest timestamp in the dataset from the first query
    earliest_timestamp = datetime.fromisoformat(data['queries'][0]['start_time'])

    # Create a list to store the runtime information
    runtime_info = []

    # Iterate over the queries
    for query in data['queries']:
        runtime_info.append(execute_query(query, earliest_timestamp))

    # Write the runtime information to a CSV file
    output_file = f"{input_file[:-5]}_runtime.csv"
    with open(output_file, 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=['Query ID', 'Runtime'])
        writer.writeheader()
        writer.writerows(runtime_info)

    print(f"Runtime information has been written to {output_file}.")

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input-file', default='../../workload/amazon/traces/TPCDS_one_day.json',
                        help='Path to the input JSON file')
    args = parser.parse_args()

    execute_queries(args.input_file)

if __name__ == '__main__':
    main()