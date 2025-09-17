# Confluent Cloud Flink Monitoring Dashboard

This directory contains an example Grafana dashboard for Confluent Cloud for Apache Flink as well as a docker-compose setup to spin up a local Grafana/Prometheus setup. Grafana is initialized with the Prometheus datasource and the example dashboard.

## Prerequisites

- **Docker and Docker Compose** - Required to run the monitoring stack
- **Confluent Cloud API Keys** - Same keys used for the workshop setup

## Setup

1. **Configure Prometheus**: Update `prometheus/prometheus.yml` with your workshop environment details:
   - Add your Confluent Cloud API Key and Secret (same as used in `demo-infrastructure/terraform.tfvars`)
   - Replace the placeholder resource IDs with values from your Terraform outputs:
     ```bash
     cd ../demo-infrastructure
     terraform output kafka_marketplace_id
     terraform output sr_prod_id  
     terraform output flink_compute_pool_id
     ```
   
   Alternatively, you can copy the configuration from the [Confluent Cloud UI](https://confluent.cloud/settings/metrics/integrations?integration=prometheus). Make sure to select "All resources" instead of the default "All Kafka clusters".

2. **Start the monitoring stack**:
   ```bash
   cd flink-monitoring
   docker-compose up -d
   ```

## Access

- **Grafana**: Available at `http://localhost:3000` 
  - Username: `admin`
  - Password: `admin`
- **Prometheus**: Available at `http://localhost:9090`

## Stopping the Services

```bash
docker-compose down
```