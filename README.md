# Terraform AWS EC2 Project

## Features
- Remote backend (S3 - for state file storing and locking)
- Modular structure
- Environment-based setup
- EC2 provisioning

## Commands
1 way --> create definition of backend in env/dev/main.tf and provide parameters through CLI
terraform init \
  -backend-config="<bucket_name>" \
  -backend-config="key=<tfsatat_file_path>" \
  -backend-config="<region>" \
  -backend-config="use_lockfile=true"
Example:
terraform init \
  -backend-config="bucket=terraform-all-in-one-bucket-for-state-file" \
  -backend-config="key=dev/terraform.tfstate" \
  -backend-config="region=us-west-2" \
  -backend-config="use_lockfile=true"

2 way --> craete backend_parameters.hcl file in backend/ and add perramters in the file and execute below command from env/dev/

terraform init -backend-config=../../backend/backend-config.hcl

terraform plan
terraform apply
