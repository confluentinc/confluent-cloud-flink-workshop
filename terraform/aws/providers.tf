# TODO(wsa): .terraform.lock.hcl currently pins only darwin_arm64 hashes. Before
# operators run on Linux, add other platforms:
#   terraform providers lock -platform=linux_amd64 -platform=darwin_arm64
terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = ">= 2.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key    # or TF_VAR_confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret # or TF_VAR_confluent_cloud_api_secret
}
