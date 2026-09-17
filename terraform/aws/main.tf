# Per-account root for the Confluent Cloud Flink "marketplace" workshop.
# One apply provisions a fully self-contained Confluent Cloud environment for a
# single attendee: environment, Kafka cluster, Schema Registry, Flink compute
# pools, data-generation Flink statements, tags, and (when confluent_cloud_email
# is set) attendee login RBAC. There is no shared infrastructure — every
# attendee's environment is independent, so WSA runs this as its only phase.

module "marketplace" {
  source = "../modules/confluent-flink-marketplace"

  prefix                = var.prefix
  cloud_region          = var.cloud_region
  confluent_cloud_email = var.confluent_cloud_email
}
