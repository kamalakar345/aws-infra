locals {

# importing the configs <tfvars> both common and cluster specific
  env_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/${basename(get_original_terragrunt_dir())}.hcl")
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

# Common Network Configuration Details
  vpc_id                                  = local.env_vars.locals.vpc_id
  vpc_cidr                                = local.env_vars.locals.vpc_cidr
  allowed_cidr_block                      = setunion(local.env_vars.locals.vpc_cidr, ["10.0.0.0/8", "100.0.0.0/8", "172.28.40.0/21"])

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = local.env_vars.locals.version_no          
  private_subnet_ids                      = local.env_vars.locals.private_subnet_ids            
  instance_types                          = local.env_vars.locals.instance_types        
  ami_type                                = local.env_vars.locals.ami_type  
  eks_cluster_name                        = "${local.env}-${local.component}-eks"
  desired_size                            = local.env_vars.locals.desired_size      
  max_size                                = local.env_vars.locals.max_size      
  min_size                                = local.env_vars.locals.min_size      
  /* allowed_cidr_block                      = local.env_vars.locals.allowed_cidr_block */
  /* eks_endpoint_service_tag                = "${local.env}-${split("-", "${local.component}")[0]}-private-eks-eps" */
# ACM Specific Configuration
  domain                                  = "na-rpb.demo.aware.qualcomm.com"

# alb-contoller specific Configurations
  public_subnet_id                        = local.env_vars.locals.public_subnet_id

## Lambda Speicific Configurations
  service_function_name                   = "service_portal_logout_reload"
  service_logout_tg                       = "service-portal-logout-reload-tg"
  service_portal_name                     = "portal.na-rpb.demo.aware.qualcomm.com"
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
module "eks" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//EKS"
    version_no                            = "${local.version_no}"
    vpc_id                                = "${local.vpc_id}"
    private_subnet_ids                    = ${jsonencode(local.private_subnet_ids)}
    instance_types                        = ${jsonencode(local.instance_types)}
    ami_type                              = "${local.ami_type}"
    eks_cluster_name                      = "${local.eks_cluster_name}"
    desired_size                          = "${local.desired_size}"
    max_size                              = "${local.max_size}"
    min_size                              = "${local.min_size}"
    allowed_cidr_block                    = ${jsonencode(local.vpc_cidr)}
    domain                                = "${local.domain}"
    vpc_cidr                              = ${jsonencode(local.vpc_cidr)}
    aws_account                           = ${local.aws_account}
    lb_scheme                             = "internet-facing"
    lb_internal                           = "false"
    nginx_subnet_ids                      = ${jsonencode(local.public_subnet_id)}
    private_link                          = false
    alb_controller                        = true
    alb_subnet_id                         = ${jsonencode(local.public_subnet_id)}
    depends_on                            = [ module.ACM ]
}

module "service-lambda" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//lambda"
    function_name                         = "${local.service_function_name}"
    logout_tg                             = "${local.service_logout_tg}"
    portal_name                           = "${local.service_portal_name }" 
}

 module "ACM" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//ACM"
    domain                                = "${local.domain}"
  }
module "hosted-zone" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//hosted-zone"
    subdomain_name                        = "${local.domain}"
}

EOF
}

# Generating Output.tf 
generate "output"{
  path = "output.tf"
  if_exists = "overwrite"
  contents = <<EOF
  output "EKS" {
    value = module.eks
  }

  output "ACM" {
      value = module.ACM
  }
  output "hosted-zone"{
    value = module.hosted-zone
  }
  output "service-lambda"{
    value = module.service-lambda
  }
EOF
}
