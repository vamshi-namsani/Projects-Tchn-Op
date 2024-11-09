

provider "google" {
  project     = "devops-project-420914"
    credentials = file("key.json")

  region      = "us-central"
}

variable "datasets" {
  
}

locals {
  datasets = var.datasets
  tables = flatten([
    for dataset_id, tables in local.datasets : [
      for table in tables: {
        dataset_id   = dataset_id
        table_id     = table.table_id
        schema_file  = table.schema_file
      }
    ]
  ])
}

resource "google_bigquery_dataset" "datasets" {
  for_each   = local.datasets
  dataset_id = each.key
}

resource "google_bigquery_table" "table" {
  for_each   = { for table_key, table in local.tables : table_key => table }

  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id
  schema     = file(each.value.schema_file)

  depends_on = [
    google_bigquery_dataset.datasets
  ]
}
