terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.12.0"
    }
  }
}

provider "confluent" {
  organization_id       = var.org_id
  environment_id        = var.env_id
  flink_compute_pool_id = var.flink_compute_pool_id
  flink_rest_endpoint   = var.flink_rest_endpoint
  flink_api_key         = var.flink_developer_sa_flink_api_key_id
  flink_api_secret      = var.flink_developer_sa_flink_api_key_secret
  flink_principal_id    = var.flink_app_sa_id

  kafka_id            = var.kafka_marketplace_id
  kafka_rest_endpoint = var.kafka_marketplace_rest_endpoint
  kafka_api_key       = var.kafka_marketplace_api_key_id
  kafka_api_secret    = var.kafka_marketplace_api_key_secret

  schema_registry_id            = var.sr_prod_id
  schema_registry_rest_endpoint = var.sr_prod_connection
  schema_registry_api_key       = var.sr_prod_api_key_id
  schema_registry_api_secret    = var.sr_prod_api_key_secret
}