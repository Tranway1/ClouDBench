from google.cloud import bigquery_datatransfer

transfer_client = bigquery_datatransfer.DataTransferServiceClient()

project_id = "dbgroup"
parent = transfer_client.common_project_path(project_id)

configs = transfer_client.list_transfer_configs(parent=parent)
print("Got the following configs:")
for config in configs:
    transfer_client.delete_transfer_config(name=config.name)
