# Set the container profile name as a local variable
locals {
 # Default value, can be overridden in root terragrunt.hcl
  aws_region = "us-west-2"
  env = regex("feature/", get_env("BRANCH_NAME"))
  aws_profile = get_env("BRANCH_NAME")
}

# Generate the provider.tf file
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  # Content of provider.tf
  contents = <<EOF
provider "aws" {

  region  = "${local.aws_region}"
  profile = "${local.aws_profile}"
  default_tags {
    tags = {
      managed         = "terraform_managed"
      admin_contact   = "aware.infra.admins@qti.qualcomm.com"
      service_id      = "QCSS Aware"
      service_data    = "env=TST"
    }
  }
}
EOF
}

#Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = false
    bucket         = "${local.env}-tfstate-bucket"
    # key            = "${path_relative_to_include()}/terraform.tfstate"
    key            = "${basename(path_relative_to_include())}.tfstate"
    region         = local.aws_region
    profile = "${local.aws_profile}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}