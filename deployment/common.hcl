/* terraform {
  source = "your-terraform-module-source"

  # Other Terraform configurations and backend settings here
} */

# Set the container profile name as a local variable
locals {
 # Default value, can be overridden in root terragrunt.hcl
  aws_region = "us-west-2"
  # env = read_terragrunt_config(get_original_terragrunt_dir())

  
  # terragrunt_dir = find_in_parent_folders("common.hcl")
  //env = basename(local.terragrunt_dir)
  # env = basename(dirname(get_original_terragrunt_dir()))
  env = get_env("BRANCH")



  # Automatically load account-level variables
  # env = read_terragrunt_config(find_in_parent_folders("common.hcl"))

  # # Automatically load region-level variables
  # region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # # Automatically load environment-level variables
  # environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  # aws_region   = local.region_vars.locals.aws_region
  # aws_profile = 
}

# Generate the provider.tf file
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  # Content of provider.tf
  contents = <<EOF
provider "aws" {

  region  = "${local.aws_region}"
  default_tags {
    tags = {
      managed = "terraform_managed"
    }
  }
}
EOF
}
#   # Template to generate the backend file
# generate "backend" {
#   path      = "backend.tf"
#   if_exists = "overwrite_terragrunt"
#   contents = <<EOF
# terraform {
#   backend "s3" {
#     bucket         = "${local.env}-tfstate-bucket"
#     key            = "${local.env}/${path_relative_to_include()}/terraform.tfstate"


#   }
# }
# EOF
# }

#Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"
  config = {
    encrypt        = false
    bucket         = "${local.env}-tfstate-bucket"
    # key            = "${path_relative_to_include()}/terraform.tfstate"
    key            = "${basename(path_relative_to_include())}.tfstate"
    region         = local.aws_region
    # dynamodb_table = "terraform-locks"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

     /* bucket         = "dev-pentest-tfbucket"
     key            = "dev_pentest_glb.tfstate" */
# inputs = {
#   # local.account_vars.locals,
#   # local.region_vars.locals,
#   env = local.env
# }

