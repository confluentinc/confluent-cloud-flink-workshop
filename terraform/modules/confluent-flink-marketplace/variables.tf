variable "prefix" {
  description = "Prefix for resource names (per-attendee, e.g. wp001)"
  type        = string
}

variable "cloud_region" {
  description = "Cloud region for the Kafka cluster and Flink compute pools"
  type        = string
  default     = "us-east-2"
}

variable "confluent_cloud_email" {
  description = "Workshop attendee email — when set, grants the attendee EnvironmentAdmin RBAC so they can log into the Confluent Cloud UI for their environment"
  type        = string
  default     = ""
}
