## Clusters

## Flights Cluster

resource "confluent_kafka_cluster" "marketplace" {
  display_name = "marketplace"
  availability = "MULTI_ZONE"
  cloud        = "AWS"
  region       = data.confluent_flink_region.flink_region.region
  standard {}

  environment {
    id = confluent_environment.env.id
  }

  depends_on = [
    confluent_environment.env
  ]
}

resource "confluent_api_key" "marketplace-kafka-api-key" {
  display_name = "marketplace-kafka-api-key"
  description  = "Kafka API Key for 'marketplace' cluster"
  owner {
    id          = confluent_service_account.env-manager.id
    api_version = confluent_service_account.env-manager.api_version
    kind        = confluent_service_account.env-manager.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.marketplace.id
    api_version = confluent_kafka_cluster.marketplace.api_version
    kind        = confluent_kafka_cluster.marketplace.kind

    environment {
      id = confluent_environment.env.id
    }
  }

  depends_on = [
    confluent_kafka_cluster.marketplace,
    confluent_service_account.env-manager
  ]
}