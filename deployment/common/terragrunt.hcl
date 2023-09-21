locals {

# importing the configs <tfvars> both common and cluster specific
  common_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/common_config.hcl")

  # env = basename(dirname(get_original_terragrunt_dir()))
  env = split("/", get_env("BRANCH_NAME"))[1]
  component = basename(get_terragrunt_dir())

# Common variable reference comming from common_config.hcl 
  region                                  = local.common_vars.locals.region
  admin_contact                           = local.common_vars.locals.admin_contact
  service_id                              = local.common_vars.locals.service_id
  aws_account                             = local.common_vars.locals.aws_account
  service_data                            = "${local.env}-${local.component}"

# ECR Specific Configuration
  aware_services                          = local.common_vars.locals.aware_services

# S3 Specific Configuration
  bucket_name                             = "aware-${local.env}-${local.component}-bucket"
}

# Include the common.hcl
include "common"{
  path = "${get_path_to_repo_root()}/deployment/common.hcl"
  merge_strategy = "deep"

}

# Generate main.tf which calls all the custom modules
generate "main" {
  path      = "main.tf"
  if_exists = "overwrite"

  contents = <<EOF
module "ECR" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//ECR"
    repository_name                       = ${jsonencode(local.aware_services)}

}

EOF
}


# Generating Output.tf 
generate "output"{
  path = "output.tf"
  if_exists = "overwrite"
  contents = <<EOF
  /* output "s3" {
    value = module.s3
  } */

  output "ECR" {
      value = module.ECR
  }
EOF
}
