terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    kestra = {
      source  = "kestra-io/kestra"
    }
    http = {
      source  = "hashicorp/http"
    }
  }
}

provider "google" {
  credentials = base64decode(var.gcp_creds)
  project     = var.project
  region      = var.region
}

data "google_storage_bucket" "existing_bucket" {
  name = var.gcs_bucket_name
}

# Если корзина не существует, создаем её
resource "google_storage_bucket" "demo-bucket" {
  count         = length(data.google_storage_bucket.existing_bucket) == 0 ? 1 : 0  # Создаем только если не существует
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true

  lifecycle {
    prevent_destroy = false
  }

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

data "google_bigquery_dataset" "existing_dataset" {
  dataset_id = var.bq_dataset_name
}

resource "google_bigquery_dataset" "demo_dataset" {
  count      = length(data.google_bigquery_dataset.existing_dataset) == 0 ? 1 : 0  # Создаем только если не существует
  dataset_id = var.bq_dataset_name
  location   = var.location
  
  lifecycle {
    prevent_destroy = false     # Разрешить удаление ресурса
	ignore_changes = [dataset_id]
  }
}

provider "kestra" {
  url   = "http://kestra:8080"
}

resource "kestra_kv" "gcp_project_id" {
  namespace = "final_project"
  key       = "GCP_PROJECT_ID"
  value     = jsonencode(var.project)
}

resource "kestra_kv" "gcp_location" {
  namespace = "final_project"
  key       = "GCP_LOCATION"
  value     = var.location
}

resource "kestra_kv" "gcp_bucket_name" {
  namespace = "final_project"
  key       = "GCP_BUCKET_NAME"
  value     = jsonencode(var.gcs_bucket_name)
}

resource "kestra_kv" "gcp_dataset" {
  namespace = "final_project"
  key       = "GCP_DATASET"
  value     = jsonencode(var.bq_dataset_name)
}

resource "kestra_kv" "gcp_creds" {
  namespace = "final_project"
  key       = "GCP_CREDS"
  value     = jsonencode(base64decode(var.gcp_creds))
}

resource "kestra_flow" "gcp_natality_flow" {
  namespace = "final_project"
  flow_id   = "gcp_natality_flow"
  content   = file("${path.module}/gcp_natality_flow.yaml")
}