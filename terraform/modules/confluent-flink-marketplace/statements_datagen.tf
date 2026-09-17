# Data-generation Flink statements.
#
# WSA hardening vs. the single-tenant demo: `confluent_flink_statement` creates
# are non-idempotent and the provider waits for the statement to reach RUNNING.
# If that create succeeds server-side but errors client-side (a transient blip,
# or submitting into a compute pool that is not ready yet), the statement is
# orphaned — created in Confluent Cloud but never written to Terraform state —
# and its fixed name is permanently reserved in the environment, so every retry
# fails with 409 Conflict. To make the first apply succeed reliably (so no retry
# into a poisoned environment is needed), we:
#   1. Wait for the data-generation pool + Flink RBAC to settle before any submit
#      (time_sleep.datagen_pool_ready), and
#   2. Submit the statements one at a time (a linear depends_on chain) rather than
#      firing all eight concurrently, which avoids the concurrent-submit burst.
# If an account still fails with a 409 name conflict, do not retry into the same
# environment (the name stays reserved) — rebuild the account fresh so it gets a
# new environment with a clean statement namespace.

resource "time_sleep" "datagen_pool_ready" {
  create_duration = "30s"

  depends_on = [
    confluent_flink_compute_pool.data-generation,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app,
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write,
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
  ]
}

locals {
  # Common wiring shared by every data-generation statement.
  datagen_catalog  = confluent_environment.env.display_name
  datagen_database = "marketplace"
}

# 1. payments table (DDL) — chain head, gated on the pool being ready.
resource "confluent_flink_statement" "payments-create-table" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/payments-create-table.sql")
  statement_name = "payments-create-table"

  depends_on = [time_sleep.datagen_pool_ready]
}

# 2. orders table (DDL)
resource "confluent_flink_statement" "orders-create-table" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/orders-create-table.sql")
  statement_name = "orders-create-table"

  depends_on = [confluent_flink_statement.payments-create-table]
}

# 3. order_status table (DDL)
resource "confluent_flink_statement" "order_status-create-table" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/order_status-create-table.sql")
  statement_name = "order-status-create-table"

  depends_on = [confluent_flink_statement.orders-create-table]
}

# 4. customer_inquiries table (DDL)
resource "confluent_flink_statement" "customer_inquiries-create-table" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/customer_inquiries-create-table.sql")
  statement_name = "customer-inquiries-create-table"

  depends_on = [confluent_flink_statement.order_status-create-table]
}

# 5. clicks datagen (CTAS)
resource "confluent_flink_statement" "clicks" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/clicks-datagen.sql")
  statement_name = "clicks-datagen"

  depends_on = [confluent_flink_statement.customer_inquiries-create-table]
}

# 6. customers datagen (CTAS)
resource "confluent_flink_statement" "customers" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/customers-datagen.sql")
  statement_name = "customers-datagen"

  depends_on = [confluent_flink_statement.clicks]
}

# 7. products datagen (CTAS)
resource "confluent_flink_statement" "products" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/products-datagen.sql")
  statement_name = "products-datagen"

  depends_on = [confluent_flink_statement.customers]
}

# 8. orders/payments/order_status INSERT set — chain tail; needs the 4 DDL
#    tables to exist and comes after the datagen CTAS statements.
resource "confluent_flink_statement" "orders-payments-order_status" {
  organization {
    id = data.confluent_organization.my_org.id
  }
  environment {
    id = confluent_environment.env.id
  }
  compute_pool {
    id = confluent_flink_compute_pool.data-generation.id
  }
  principal {
    id = confluent_service_account.flink-app.id
  }

  rest_endpoint = data.confluent_flink_region.flink_region.rest_endpoint

  credentials {
    key    = confluent_api_key.flink-developer-sa-flink-api-key.id
    secret = confluent_api_key.flink-developer-sa-flink-api-key.secret
  }

  properties = {
    "sql.current-catalog"  = local.datagen_catalog
    "sql.current-database" = local.datagen_database
  }

  statement      = file("${path.module}/statements/orders-payments-order_status-datagen.sql")
  statement_name = "orders-datagen"

  depends_on = [
    confluent_flink_statement.products,
    confluent_flink_statement.payments-create-table,
    confluent_flink_statement.orders-create-table,
    confluent_flink_statement.order_status-create-table,
    confluent_flink_statement.customer_inquiries-create-table,
  ]
}
