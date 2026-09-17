variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (Cloud resource management, OrganizationAdmin)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "Per-attendee resource prefix (e.g. wp001)"
  type        = string
}

variable "cloud_region" {
  description = "Cloud region for the Kafka cluster and Flink compute pools"
  type        = string
  default     = "us-east-2"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.cloud_region))
    error_message = "cloud_region must be a valid region, e.g. us-east-2."
  }
}

variable "confluent_cloud_email" {
  description = "Workshop attendee email — grants EnvironmentAdmin RBAC so the attendee can log into the Confluent Cloud UI for their environment"
  type        = string
  default     = ""
}
