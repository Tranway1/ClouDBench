from google.cloud import bigquery
from google.cloud import bigquery_datatransfer
from google.protobuf.timestamp_pb2 import Timestamp
from datetime import datetime
import time
import re
import pandas as pd
import argparse
import csv

'''
Used for transferring tpch dataset from S3 to BigQuery and translating RedShift queries to BigQuery
'''

# Construct a BigQuery client object.
client = bigquery.Client()
SFS = [1, 3, 10, 30, 100, 300, 1000, 3000]
TABLES = ["region", "nation", "customer", "orders", "lineitem", "partsupp", "supplier", "part"]
TABLE_NAMES = set(t + '_' + str(s) for t in TABLES for s in SFS) | set(t + '_' + 'copy_' + str(s) for t in TABLES for s in range(602))

def create_tables():
    with open("schema.sql", "r") as f:
        query = f.read()

    query_job = client.query(query)
    results = query_job.result()
    for row in results:
        print("{} : {} views".format(row.url, row.view_count))

def setup():
    for sf in SFS:
        for table in TABLES:
            client = bigquery_datatransfer.DataTransferServiceClient()
            parent = client.common_project_path('dbgroup')
            dest_dataset = "tpch"
            transfer_config = bigquery_datatransfer.TransferConfig()
            transfer_config.destination_dataset_id = dest_dataset
            transfer_config.display_name = "copy_neural_science"
            transfer_config.data_source_id = "amazon_s3"
            transfer_config.disabled = False
            transfer_config.params = {
                'destination_table_name_template': table.split('.')[0] + '_' + str(sf),
                'data_path': 's3://neural-science/aws/data/sf-' + str(sf) + '/' + table + '*',  # change for part table
                'access_key_id': '',
                'secret_access_key': '',
                'file_format': 'CSV',
                'field_delimiter': '|',
                'allow_jagged_rows': "true",
                "allow_quoted_newlines": "true"
                }

            request = bigquery_datatransfer.CreateTransferConfigRequest(
                parent=parent,
                transfer_config=transfer_config
            )

            # Make the request
            response = client.create_transfer_config(request=request)

    # Handle the response
    print(response)
    time.sleep(5)

def validate():
    def validate_table(sf, table, min, max):
        sql = f"select count(*) from {'tpch.' + table + '_' + str(sf)};"
        query_job = client.query(sql)
        result = query_job.result()
        row = next(result)
        cnt = row[0]
        print(f"validating table={table} has={cnt} min={min} max={max}")
        if not (min <= cnt and cnt <= max):
            raise Exception(f"not in bounds {cnt}")

    for sf in SFS:
        print(f"sf={sf}")
        validate_table(sf, "region", 5, 5)
        validate_table(sf, "nation", 25, 25)
        validate_table(sf, "customer", sf * 150000, sf * 150000)
        validate_table(sf, "orders", sf * 1500000, sf * 1500000)
        validate_table(sf, "lineitem", (sf * 6000000) * 0.99, (sf * 6000000) * 1.01)
        validate_table(sf, "partsupp", sf * 800000, sf * 800000)
        validate_table(sf, "part", sf * 200000, sf * 200000)
        validate_table(sf, "supplier", sf * 10000, sf * 10000)

def fix_query(query):
    date_add = r"dateadd\(year, (\d+), '(\d{4}-\d{2}-\d{2})'::date\)"
    date_a_g = r"date_add('\2'::date, interval \1 year)"
    query = re.sub(date_add, date_a_g, query)
    month_add = r"add_months\(('[^']+'::date),\s*(\d+)\)"
    month_replace = r"date_add(\1, interval \2 month)"
    query = re.sub(month_add, month_replace, query)
    date_pattern = r"('\d{4}-\d{2}-\d{2}')::date"
    date_replacement = r"DATE(\1)"
    query = re.sub(date_pattern, date_replacement, query)
    float_cast = r"(\d+(\.\d+)?)::numeric\(\d+,\d+\)"
    float_replace = r"\1"
    query = re.sub(float_cast, float_replace, query)
    int_cast = r"(\d+)::int"
    int_replace = r"\1"
    query = re.sub(int_cast, int_replace, query)

    pattern = r'(\bFROM\s+|\bJOIN\s+|\bUPDATE\s+|\bINTO\s+|\bWHERE\s+|\bCREATE\s+TABLE\s+|\bDROP\s+TABLE\s+)([\w.]+(?:\s*,\s*[\w.]+)*(?:\s*,\s*[\w.\s]+)*)'
    prefix = 'tpch.'

    def add_prefix(match):
        if match.group():
            keyword = match.group(1)
            tables = match.group(2).split(',')
            modified_tables = [f'{prefix}{table.strip()}' if table.strip() in TABLE_NAMES else table.strip() for table in tables]
            return f'{keyword}{", ".join(modified_tables)}'

    query = re.sub(pattern, add_prefix, query, flags=re.IGNORECASE | re.DOTALL)
    return query

def fix_queries(input_file):
    data = pd.read_csv(input_file)
    data.sort_values(by='starttime', ascending=True, inplace=True)
    
    for ind, row in data.iterrows():
        query = fix_query(row['sql'])
        data.loc[ind, 'sql'] = query

    data.to_csv(input_file, index=False)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--queries', default='../../../workload/amazon/traces/red2/bigQuery/c2_with_queries.csv',
                        help='Path to the input csv file')
    
    args = parser.parse_args()
    # create_tables()
    # setup()
    # validate()
    # fix_queries(args.queries)