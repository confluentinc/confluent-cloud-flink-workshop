resource "confluent_tag" "pii" {
  name = "PII"
  description = "Personal Identifiable Information"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  depends_on = [
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]
}

resource "confluent_tag" "public" {
  name = "public"
  description = "company-public streams"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  depends_on = [
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]
}

resource "confluent_tag" "private" {
  name = "private"
  description = "private streams"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  depends_on = [
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]

}


resource "confluent_tag_binding" "customers-pii" {
  tag_name = "PII"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  entity_name = "${data.confluent_schema_registry_cluster.sr.id}:${confluent_kafka_cluster.marketplace.id}:customers"
  entity_type = "kafka_topic"

  depends_on = [
    confluent_flink_statement.customers,
    confluent_tag.pii, 
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]
}

resource "confluent_tag_binding" "customers-private" {
  tag_name = "private"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  entity_name = "${data.confluent_schema_registry_cluster.sr.id}:${confluent_kafka_cluster.marketplace.id}:customers"
  entity_type = "kafka_topic"

  depends_on = [
    confluent_flink_statement.customers,
    confluent_tag.private, 
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key,
    confluent_api_key.schema-registry-api-key
  ]
}

resource "confluent_tag_binding" "clicks-private" {
  tag_name = "private"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  entity_name = "${data.confluent_schema_registry_cluster.sr.id}:${confluent_kafka_cluster.marketplace.id}:clicks"
  entity_type = "kafka_topic"

  depends_on =[
    confluent_flink_statement.clicks,
    confluent_tag.private, 
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]
}

resource "confluent_tag_binding" "products-public" {
  tag_name = "public"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  entity_name = "${data.confluent_schema_registry_cluster.sr.id}:${confluent_kafka_cluster.marketplace.id}:products"
  entity_type = "kafka_topic"

  depends_on =[
    confluent_flink_statement.products,
    confluent_tag.public, 
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]
}

resource "confluent_tag_binding" "orders-private" {
  tag_name = "private"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  entity_name = "${data.confluent_schema_registry_cluster.sr.id}:${confluent_kafka_cluster.marketplace.id}:orders"
  entity_type = "kafka_topic"

  depends_on = [
    confluent_flink_statement.orders-create-table,
    confluent_tag.private, 
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]
}

resource "confluent_tag_binding" "payments-private" {
  tag_name = "private"

  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.sr.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.sr.rest_endpoint
  credentials {
    key    = confluent_api_key.schema-registry-api-key.id
    secret = confluent_api_key.schema-registry-api-key.secret
  }

  entity_name = "${data.confluent_schema_registry_cluster.sr.id}:${confluent_kafka_cluster.marketplace.id}:payments"
  entity_type = "kafka_topic"

  depends_on = [
    confluent_flink_statement.payments-create-table,
    confluent_tag.private, 
    confluent_role_binding.env-admin,
    confluent_api_key.schema-registry-api-key
  ]
}