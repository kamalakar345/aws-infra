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
module "s3" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//EKS"
    version_no                            = "${local.version_no}"
    vpc_id                                = "${local.vpc_id}"
    private_subnet_ids                    = ${jsonencode(local.private_subnet_ids)}
    /* public_subnet_id                      = {jsonencode(local.public_subnet_id)} */
    instance_types                        = ${jsonencode(local.instance_types)}
    ami_type                              = "${local.ami_type}"
    eks_cluster_name                      = "${local.eks_cluster_name}"
    desired_size                          = "${local.desired_size}"
    max_size                              = "${local.max_size}"
    min_size                              = "${local.min_size}"
    allowed_cidr_block                    = ${jsonencode(local.vpc_cidr)}
    domain                                = "${local.domain}"
    vpc_cidr                              = ${jsonencode(local.vpc_cidr)}
    private_link                          = false
    aws_account                           = ${local.aws_account}
    depends_on                            = [ module.ACM ]
}

 /* module "ecr" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//ACM"
  } */

EOF
}


# Generating Output.tf 
generate "output"{
  path = "output.tf"
  if_exists = "overwrite"
  contents = <<EOF
  output "s3" {
    value = module.s3
  }

  output "ecr" {
      value = module.ecr
  }
EOF
}
