resource "confluent_flink_statement" "clicks" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/clicks-datagen.sql")
  statement_name = "clicks-datagen"

  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}

resource "confluent_flink_statement" "customers" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/customers-datagen.sql")
  statement_name = "customers-datagen"

  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}
resource "confluent_flink_statement" "products" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/products-datagen.sql")
  statement_name = "products-datagen"

  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}

resource "confluent_flink_statement" "orders-payments-order_status" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/orders-payments-order_status-datagen.sql")
  statement_name = "orders-datagen"

  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin, 
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_flink_statement.payments-create-table, 
    confluent_flink_statement.orders-create-table,
    confluent_flink_statement.order_status-create-table, 
    confluent_flink_statement.customer_inquiries-create-table,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}

resource "confluent_flink_statement" "payments-create-table" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/payments-create-table.sql")
  statement_name = "payments-create-table"

  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}

resource "confluent_flink_statement" "orders-create-table" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/orders-create-table.sql")
  statement_name = "orders-create-table"

  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}

resource "confluent_flink_statement" "order_status-create-table" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/order_status-create-table.sql")
  statement_name = "order-status-create-table"


  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}

resource "confluent_flink_statement" "customer_inquiries-create-table" {

  organization {
    id = data.confluent_organization.my_org.id
  }

   environment {
    id = confluent_environment.env.id
  }

  compute_pool  {
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
    "sql.current-catalog"  = confluent_environment.env.display_name
    "sql.current-database" = "marketplace"
  }

  statement  = file("${path.module}/statements/customer_inquiries-create-table.sql")
  statement_name = "customer-inquiries-create-table"


  depends_on  = [
    confluent_role_binding.flink-app-sr-read,
    confluent_role_binding.flink-app-sr-write, 
    confluent_role_binding.flink-app-clusteradmin,
    confluent_role_binding.flink-developer-sa-flink-developer,
    confluent_role_binding.app-manager-assigner,
    confluent_api_key.flink-developer-sa-flink-api-key,
    confluent_service_account.flink-app
  ]

}