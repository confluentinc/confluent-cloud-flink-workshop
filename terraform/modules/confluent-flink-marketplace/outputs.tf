output "org_id" {
  value = data.confluent_organization.my_org.id
}

output "env_id" {
  value = confluent_environment.env.id
}

output "env_name" {
  value = confluent_environment.env.display_name
}

output "env_resource_name" {
  value = confluent_environment.env.resource_name
}

# Kafka Cluster

output "kafka_marketplace_id" {
  value = confluent_kafka_cluster.marketplace.id
}

output "kafka_marketplace_bootstrap_endpoint" {
  value = confluent_kafka_cluster.marketplace.bootstrap_endpoint
}

output "kafka_marketplace_rest_endpoint" {
  value = confluent_kafka_cluster.marketplace.rest_endpoint
}

output "kafka_marketplace_api_key_id" {
  value = confluent_api_key.marketplace-kafka-api-key.id
}

output "kafka_marketplace_api_key_secret" {
  value     = confluent_api_key.marketplace-kafka-api-key.secret
  sensitive = true
}

# Schema Registry

output "sr_prod_id" {
  value = data.confluent_schema_registry_cluster.sr.id
}

output "sr_prod_connection" {
  value = data.confluent_schema_registry_cluster.sr.rest_endpoint
}

output "sr_prod_api_key_id" {
  value = confluent_api_key.schema-registry-api-key.id
}

output "sr_prod_api_key_secret" {
  value     = confluent_api_key.schema-registry-api-key.secret
  sensitive = true
}

# Flink

output "flink_app_sa_id" {
  value = confluent_service_account.flink-app.id
}

output "flink_developer_sa_id" {
  value = confluent_service_account.flink-developer-sa.id
}

output "flink_developer_sa_flink_api_key_id" {
  value = confluent_api_key.flink-developer-sa-flink-api-key.id
}

output "flink_developer_sa_flink_api_key_secret" {
  value     = confluent_api_key.flink-developer-sa-flink-api-key.secret
  sensitive = true
}

output "flink_compute_pool_id" {
  value = confluent_flink_compute_pool.default.id
}

output "flink_rest_endpoint" {
  value = data.confluent_flink_region.flink_region.rest_endpoint
}
