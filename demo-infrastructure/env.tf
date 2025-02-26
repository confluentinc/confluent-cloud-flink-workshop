resource "random_id" "display_id" {
    byte_length = 4
}

resource "confluent_environment" "env" {
  display_name = "${var.prefix}-prod-${random_id.display_id.hex}"

  stream_governance {
    package = "ADVANCED"
  }
}

resource "confluent_service_account" "env-manager" {
  display_name = "${var.prefix}-prod-env-manager-${random_id.display_id.hex}"
  description  = "Service account to manage 'prod' environment"

  depends_on = [
    confluent_environment.env
  ]
}

resource "confluent_role_binding" "env-admin" {
  principal   = "User:${confluent_service_account.env-manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.env.resource_name
}

data "confluent_schema_registry_cluster" "sr" {

  environment {
    id = confluent_environment.env.id
  }

  depends_on = [
    confluent_kafka_cluster.marketplace
  ]
}

resource "confluent_api_key" "schema-registry-api-key" {
  display_name = "env-manager-schema-registry-api-key"
  description  = "Schema Registry API Key that is owned by 'env-manager' service account"
  owner {
    id          = confluent_service_account.env-manager.id
    api_version = confluent_service_account.env-manager.api_version
    kind        = confluent_service_account.env-manager.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.sr.id
    api_version = data.confluent_schema_registry_cluster.sr.api_version
    kind        = data.confluent_schema_registry_cluster.sr.kind

    environment {
      id = confluent_environment.env.id
    }
  }

  depends_on = [
      confluent_service_account.env-manager
  ]
}