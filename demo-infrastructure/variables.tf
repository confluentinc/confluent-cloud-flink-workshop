variable "prefix" {
  description = "Prefix for resource names with your initials"
  type        = string
}

variable "cloud_region"{
  description = "AWS Cloud Region"
  type        = string
  default     = "us-east-2"    
}

variable "confluent_cloud_api_key"{
    description = "Confluent Cloud API Key"
    type        = string
}

variable "confluent_cloud_api_secret"{
    description = "Confluent Cloud API Secret"
    type        = string     
}

