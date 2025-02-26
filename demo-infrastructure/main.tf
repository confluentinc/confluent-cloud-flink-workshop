terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.12.0"
    }
  }
}

provider "confluent" {
  endpoint = "https://confluent.cloud/api"
  cloud_api_key    = var.confluent_cloud_api_key    # optionally use TF_VAR_confluent_cloud_api_key env var
  cloud_api_secret = var.confluent_cloud_api_secret # optionally use TF_VAR_confluent_cloud_api_secret env var
}


data "confluent_flink_region" "flink_region" {
  cloud  = "AWS"
  region = var.cloud_region
}


data "confluent_organization" "my_org" {}








