variable "project" {
  description = "Project ID"
  default     = "fair-canto-447119-p5" # ADD YOUR PROJECT ID
}

variable "location" {
  description = "Project Location"
  default     = "US" # ADD LOCATION OF YOUR PROJECT
}

variable "region" {
  description = "Region"
  default     = "us-central" # ADD REGION OF YOUR PROJECT
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "project_dataset"  # NOT CHANGE
}

variable "gcs_bucket_name" {
  description = "My Storage Bucker Name"
  default     = "project-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucker Storage Class"
  default     = "STANDART"
}

variable "gcp_creds" {
  type      = string
  sensitive = true  # Помечаем переменную как чувствительную
}