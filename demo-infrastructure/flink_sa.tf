resource "confluent_service_account" "flink-app" {
  display_name = "${var.prefix}-prod-flink-app-${random_id.display_id.hex}"
  description  = "Service account as which Flink Statements run in prod environment"

  depends_on = [
    confluent_environment.env
  ]
}

resource "confluent_service_account" "flink-developer-sa" {
  display_name = "${var.prefix}-flink-developer-sa-${random_id.display_id.hex}"
  description  = "Service account to run Flink Statements in prod environment"

  depends_on = [
    confluent_environment.env
  ]
}

resource "confluent_role_binding" "flink-developer-sa-flink-developer" {
  principal   = "User:${confluent_service_account.flink-developer-sa.id}"
  role_name   = "FlinkDeveloper"
  crn_pattern = confluent_environment.env.resource_name
}

resource "confluent_role_binding" "app-manager-assigner" {
 principal   = "User:${confluent_service_account.flink-developer-sa.id}"
  role_name   = "Assigner"
  crn_pattern = "${data.confluent_organization.my_org.resource_name}/service-account=${confluent_service_account.flink-app.id}"
}

resource "confluent_api_key" "flink-developer-sa-flink-api-key" {
  display_name = "flink-statement-runner-flink-api-key"
  description  = "Flink API Key that is owned by 'flink-developer-sa' service account"
  owner {
    id          = confluent_service_account.flink-developer-sa.id
    api_version = confluent_service_account.flink-developer-sa.api_version
    kind        = confluent_service_account.flink-developer-sa.kind
  }

  managed_resource {
    id          = data.confluent_flink_region.flink_region.id
    api_version = data.confluent_flink_region.flink_region.api_version
    kind        = data.confluent_flink_region.flink_region.kind

    environment {
      id = confluent_environment.env.id
    }
  }
}

resource "confluent_role_binding" "flink-app-clusteradmin" {
  principal   = "User:${confluent_service_account.flink-app.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.marketplace.rbac_crn
}


data "confluent_schema_registry_cluster" "env" {
  environment {
    id = confluent_environment.env.id
  }
  depends_on = [ 
    confluent_kafka_cluster.marketplace
  ]
}
resource "confluent_role_binding" "flink-app-sr-read" {
  principal   = "User:${confluent_service_account.flink-app.id}"
  role_name   = "DeveloperRead"
  crn_pattern = "${data.confluent_schema_registry_cluster.env.resource_name}/subject=*"
}

resource "confluent_role_binding" "flink-app-sr-write" {
  principal   = "User:${confluent_service_account.flink-app.id}"
  role_name   = "DeveloperWrite"
  crn_pattern = "${data.confluent_schema_registry_cluster.env.resource_name}/subject=*"
}