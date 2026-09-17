# ===============================
# WSA Outputs
# ===============================
# Each credential field with `source: terraform` in wsa-spec-aws.yaml maps to a
# root output here by name.

output "cc_environment_url" {
  description = "WSA: Confluent Cloud console URL for this attendee's environment"
  value       = "https://confluent.cloud/environments/${module.marketplace.env_id}"
}

output "cc_environment_id" {
  description = "WSA: Confluent Cloud environment ID"
  value       = module.marketplace.env_id
}

output "cc_environment_name" {
  description = "WSA: Confluent Cloud environment display name (Flink catalog name)"
  value       = module.marketplace.env_name
}

output "cc_flink_compute_pool_id" {
  description = "WSA: default Flink compute pool ID"
  value       = module.marketplace.flink_compute_pool_id
}

output "cc_kafka_cluster_id" {
  description = "WSA: marketplace Kafka cluster ID"
  value       = module.marketplace.kafka_marketplace_id
}

output "cc_kafka_bootstrap_endpoint" {
  description = "WSA: marketplace Kafka bootstrap endpoint"
  value       = module.marketplace.kafka_marketplace_bootstrap_endpoint
}

# ===============================
# Passthrough outputs (parity with demo-infrastructure)
# ===============================

output "org_id" {
  value = module.marketplace.org_id
}

output "env_id" {
  value = module.marketplace.env_id
}

output "env_name" {
  value = module.marketplace.env_name
}

output "flink_compute_pool_id" {
  value = module.marketplace.flink_compute_pool_id
}

output "flink_rest_endpoint" {
  value = module.marketplace.flink_rest_endpoint
}
