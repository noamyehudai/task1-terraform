# Use Terragrunt to download the module code
terraform {
  source = "./modules"
}

# Use Terragrunt to create backend.tf 
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket = "noam-terraform-bucket"
    key = "terraform.tfstate"
    region = "eu-central-1"
  }
}

# Use Terragrunt to create provider.tf
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = var.aws_region
}
EOF
}

# Fill in the variables for that module
inputs = {
  instance_type = "t2.micro"
  aws_region = "eu-central-1"
}
