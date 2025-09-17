[![Try Confluent Cloud - The Data Streaming Platform](https://images.ctfassets.net/8vofjvai1hpv/10bgcSfn5MzmvS4nNqr94J/af43dd2336e3f9e0c0ca4feef4398f6f/confluent-banner-v2.svg)](https://confluent.cloud/signup?utm_source=github&utm_medium=banner&utm_campaign=oss-repos&utm_term=confluent-cloud-flink-workshop)

# Flink Confluent Cloud for Apache Flink Online Store Workshop

This repository sets up the necessary infrastructure for the Confluent Cloud: Getting Started with Apache Flink workshop. It simulates data for a third-party reseller offering products from major vendors like Amazon and Walmart.

During the workshop, you'll use Confluent Cloud for Apache Flink to clean, transform, and join the data, ultimately creating several data products. Below is the architecture of what you'll build.

![lab 1 and 2 architecture](flink-getting-started/img/architecture_lab2.png)

In labs 3 and 4, you will then sync these data products to Amazon S3 in Apache Iceberg format using Tableflow. Below is the architecture:

![lab 3 and 4 architecture](tableflow-labs/img/lab-3-and-4-architecture.png)

## General Requirements

* **Confluent Cloud API Keys** - [Cloud resource management API Keys](https://docs.confluent.io/cloud/current/security/authenticate/workload-identities/service-accounts/api-keys/overview.html#resource-scopes) with Organisation Admin permissions
* **Terraform (v1.9.5+)** - The demo resources is automatically created using [Terraform](https://www.terraform.io).
* **Git CLI** - Git CLI to clone the repo 
* **Confluent CLI** - Confluent CLI if Flink shell will be used.
* **Docker and Docker Compose** - Required if you want to run the optional Flink monitoring dashboard

<details>
<summary>Installing CLI tools on MAC</summary>

Install `git`, `terraform`, and `docker` by running:

```bash
brew install git terraform docker docker-compose
```

[Optional] Install `confluent` CLI by running:
```bash
brew install confluent
```


</details>


<details>
<summary>Installing CLI tools on Windows</summary>

Install `git`, `terraform`, and `docker` by running:

```powershell
winget install --id Git.Git -e
winget install --id Hashicorp.Terraform -e
winget install --id Docker.DockerDesktop -e
```
[Optional] Install `confluent` CLI by running:
```
winget install --id ConfluentInc.Confluent-CLI -e
```
</details> 


## Setup

<details>
<summary>Mac Setup</summary>

First, clone the repo and change directory to `demo-infrastructure`

```bash
git clone <repo_url>
cd confluent-cloud-flink-workshop/demo-infrastructure
```

In the `demo-infrastructure` directory, create a `terraform.tfvars` file to store the Confluent Cloud API keys required by Terraform. Replace the placeholders below with your own keys and `{prefix}` with your intials.

```bash
cat > ./terraform.tfvars <<EOF
confluent_cloud_api_key = "{Confluent Cloud API Key}"
confluent_cloud_api_secret = "{Confluent Cloud API Key Secret}"
prefix = "{prefix}"
EOF
```


In `demo-infrastructure` run the following commands to set up the whole demo environment

```bash
terraform init
terraform apply --auto-approve
```

Source the demo environment variables 


```bash
source env.sh
```

</details>

<details>
<summary>Windows Setup</summary>

First, clone the repo and change directory to `demo-infrastructure`

```bash
git clone <repo_url>
cd confluent-cloud-flink-workshop\demo-infrastructure
```

In the `demo-infrastructure` directory, create a `terraform.tfvars` file to store the Confluent Cloud API keys required by Terraform. Replace the placeholders below with your own keys and `{prefix}` with your intials.

```bash
echo confluent_cloud_api_key = "{Confluent Cloud API Key}" > terraform.tfvars
echo confluent_cloud_api_secret = "{Confluent Cloud API Key Secret}" >> terraform.tfvars
echo prefix = "{prefix}" >> terraform.tfvars
```

In `demo-infrastructure` run the following commands to set up the whole demo environment

```bash
terraform init
terraform apply --auto-approve
```

Source the demo environment variables 

```
call env.bat
```
</details>

## Labs

**Next Lab:** [Lab 1: Getting Started with Flink](./flink-getting-started/lab1.md)

## Optional: Flink Monitoring Dashboard

After completing the workshop setup, you can optionally set up a monitoring dashboard to visualize your Flink jobs and Confluent Cloud metrics:

**Monitoring Setup:** [Flink Monitoring Dashboard](./flink-monitoring/README.md)



## Tear down

In `demo-infrastructure` run the following commands to destroy the whole demo environment

```bash
terraform destroy --auto-approve
```
