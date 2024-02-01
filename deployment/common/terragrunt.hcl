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

# Glp-priv to Reg-priv Specific Configuration

## Reg private VPC Details
  reg_priv_vpc_id                         = local.common_vars.locals.reg_priv_vpc_id              
  reg_priv_private_subnet_ids             = local.common_vars.locals.reg_priv_private_subnet_ids

## Reg Public VPC Details
  reg_pub_vpc_id                          = local.common_vars.locals.reg_pub_vpc_id   
  reg_pub_private_subnet_ids              = local.common_vars.locals.reg_pub_private_subnet_ids

## Global Private VPC Details
  glb_priv_vpc_id                         = local.common_vars.locals.glb_priv_vpc_id                
  glb_priv_private_subnet_ids             = local.common_vars.locals.glb_priv_private_subnet_ids

## Global Public VPC Details
  glb_pub_vpc_id                          = local.common_vars.locals.glb_pub_vpc_id   
  glb_pub_private_subnet_ids              = local.common_vars.locals.glb_pub_private_subnet_ids

## Custom Configs for the Module
  endpoint_service_name                   = "${local.env}-regional-private-eps"              
  nlbname                                 = "${local.env}-regional-private-eps-nlb"                      
  TargetgroupName                         = "${local.env}-regional-private-eps" // need to shorten this  
  loadbalancertag                         = "${local.env}-regional-private-eks-nlb"                        
  vpc_endpointname_global_private         = "${local.env}-global-private-ep"
  globalnlbname                           = "${local.env}-global-private-ep-nlb"
  globalTargetgroupName                   = "${local.env}-global-private-ep-nlb-tg" // might need to shorten this

## Custom configs for quicksight Module
  quicksight_enabled                      = local.common_vars.locals.quicksight_enabled
  admin_user                              = local.common_vars.locals.admin_user
  quicksight_email                        = local.common_vars.locals.quicksight_email
  start_time                              = local.common_vars.locals.start_time

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

module "S3"{
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//S3"
    bucketname                            = "${local.bucket_name}"
}

module "glb-priv-to-reg-priv-pl"{
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//Glb-priv-to-Reg-priv-privatelink"

    endpoint_service_name                 = "${local.endpoint_service_name}"
    nlbname                               = "${local.nlbname}"
    subnet_id_regional                    = ${jsonencode(local.reg_priv_private_subnet_ids)}
    TargetgroupName                       = "${local.TargetgroupName}"
    vpc_id_regional_private               = ${jsonencode(local.reg_priv_vpc_id)}
    loadbalancertag                       = "${local.loadbalancertag}"
    vpc_id_global_private                 = ${jsonencode(local.glb_priv_vpc_id)}
    vpc_endpointname_global_private       = "${local.vpc_endpointname_global_private}"
    globalnlbname                         = "${local.globalnlbname}"
    subnet_id_global                      = ${jsonencode(local.glb_priv_private_subnet_ids)}
    globalTargetgroupName                 = "${local.globalTargetgroupName}"
    depends_on                            = [ module.S3 ]
}

data "aws_msk_cluster" "msk-regional-private" {
  cluster_name                            = "${local.env}-regional-private-msk"
  # depends_on                              = [ module.glb-priv-to-reg-priv-pl ]
}

data "aws_msk_cluster" "msk-global-private" {
  cluster_name                            = "${local.env}-global-private-msk"
  # depends_on                              = [ module.glb-priv-to-reg-priv-pl ]
}

data "aws_vpc_endpoint" "global_public_ep" {
    filter {
        name                              = "tag:Name"    
        values                            = ["${local.env}-global-private-msk-ep"]
    }
  # depends_on                              = [ module.glb-priv-to-reg-priv-pl ]  
}

data "aws_vpc_endpoint" "regional_public_ep" {
  filter {
        name                              = "tag:Name"    
        values                            = ["${local.env}-regional-private-msk-ep"]
    }
  # depends_on                              = [ module.glb-priv-to-reg-priv-pl ]
}

module "msk-regional-private-prv-hz" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//private-hosted-zone"
    endpoint_id                           = data.aws_vpc_endpoint.regional_public_ep.id
    cluster_arn                           = data.aws_msk_cluster.msk-regional-private.arn
    endpoint_vpc_id                       = ${jsonencode(local.reg_pub_vpc_id)}     #regional-public public vpc
    endpoint_subnet_id                    = ${jsonencode(local.reg_pub_private_subnet_ids)}  #regional-public private subnet
    depends_on                            = [ data.aws_msk_cluster.msk-regional-private, data.aws_vpc_endpoint.regional_public_ep ]
}

module "msk-global-private-prv-hz" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//private-hosted-zone"
    endpoint_id                           = data.aws_vpc_endpoint.global_public_ep.id
    cluster_arn                           = data.aws_msk_cluster.msk-global-private.arn
    endpoint_vpc_id                       = ${jsonencode(local.glb_pub_vpc_id)}
    endpoint_subnet_id                    = ${jsonencode(local.glb_pub_private_subnet_ids)}
    depends_on                            = [ data.aws_msk_cluster.msk-global-private, data.aws_vpc_endpoint.global_public_ep ]

}

module "athenaQuicksight" {
  source                                  = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//Athena"
  environment                             = "${local.env}rnd"
  region                                  = "${local.region}"
  aws_profile                             = "${local.env}"
  aws_account_id                          = "${local.aws_account}"
  quicksight_enabled                      = "${local.quicksight_enabled}"  ## flag , disable or enable to create the Quicksight account
  admin_user                              = ${jsonencode(local.admin_user)}             ## list of admin users
  quicksight_email                        = "${local.quicksight_email}"
  start_time                              = "${local.start_time}"

 }
module "firehose" {
  source                                  = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//firhose"
  environment                             = "${local.env}rnd"
  region                                  = "${local.region}"
  depends_on                              = [ module.athenaQuicksight ]
}

EOF
}


# Generating Output.tf 
generate "output"{
  path = "output.tf"
  if_exists = "overwrite"
  contents = <<EOF
  output "S3" {
    value = module.S3
  }

  output "ECR" {
      value = module.ECR
  }

  output "glb-priv-to-reg-priv-pl"{
      value = module.glb-priv-to-reg-priv-pl
  }
  output "msk-regional-private-prv-hz"{
    value = module.msk-regional-private-prv-hz
  }
  output "msk-global-private-prv-hz"{
    value = module.msk-global-private-prv-hz
  }
EOF
}
