resource "confluent_flink_compute_pool" "default" {
  display_name     = "default"
  cloud            =  upper(data.confluent_flink_region.flink_region.cloud)
  region           =  data.confluent_flink_region.flink_region.region
  max_cfu          = 50
  environment {
    id = confluent_environment.env.id
  }
}

resource "confluent_flink_compute_pool" "data-generation" {
  display_name     = "data-generation"
  cloud            =  upper(data.confluent_flink_region.flink_region.cloud)
  region           =  data.confluent_flink_region.flink_region.region
  max_cfu          = 50
  environment {
    id = confluent_environment.env.id
  }
}