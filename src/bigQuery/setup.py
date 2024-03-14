from google.cloud import bigquery
from google.cloud import bigquery_datatransfer
from google.protobuf.timestamp_pb2 import Timestamp
import os
import argparse
import json
from datetime import datetime
import time
import csv
import re
import asyncio

SFS = [1, 3, 10, 30, 100, 300, 1000, 3000]
TABLES = ["region", "nation", "customer", "orders", "lineitem", "partsupp", "supplier", "part.tbl"]

# Construct a BigQuery client object.
client = bigquery.Client()

def create_tables():
    with open("scaled_schema.sql", "r") as f:
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
                'data_path': 's3://neural-science/aws/data/sf-' + str(sf) + '/' + table + '*',
                'access_key_id': 'AKIAR7NOTFW5MPULKF65',
                'secret_access_key': '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',
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


if __name__ == '__main__':
    # create_tables()
    # setup()
    validate()