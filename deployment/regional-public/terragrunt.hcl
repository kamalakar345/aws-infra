locals {
  # importing the configs <tfvars> both common and cluster specific
  env_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/${basename(get_original_terragrunt_dir())}.hcl")
  common_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/common_config.hcl")

  env = basename(dirname(get_original_terragrunt_dir()))
  component = basename(get_terragrunt_dir())

# Common variable reference comming from common_config.hcl 
  region                            = local.common_vars.locals.region
  region_abbr                       = local.common_vars.locals.region_abbr
  environment                       = local.common_vars.locals.environment
  admin_contact                     = local.common_vars.locals.admin_contact
  service_id                        = local.common_vars.locals.service_id
  service_data                      = local.common_vars.locals.service_data
  aws_profile                       = local.common_vars.locals.aws_profile

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                        = local.env_vars.locals.version_no          
  vpc_id                            = local.env_vars.locals.vpc_id
  private_subnet_ids                = local.env_vars.locals.private_subnet_ids            
  instance_types                    = local.env_vars.locals.instance_types        
  ami_type                          = local.env_vars.locals.ami_type  
  eks_cluster_name                  = local.env_vars.locals.eks_cluster_name 
  nodename                          = local.env_vars.locals.nodename
  desired_size                      = local.env_vars.locals.desired_size      
  max_size                          = local.env_vars.locals.max_size      
  min_size                          = local.env_vars.locals.min_size      
  allowed_cidr_block                = local.env_vars.locals.allowed_cidr_block

#ingress-private-nlb Specific Configurations           
  private_vpc_cidr                  = local.env_vars.locals.private_vpc_cidr       
  private_acm_certificate           = local.env_vars.locals.private_acm_certificate
  privatesubnetids                  = local.env_vars.locals.privatesubnetids       
  private_DNS                       = local.env_vars.locals.private_DNS            

# "EKS-privatelink" Specific Configurations
  eks_endpoint_service_name         = local.env_vars.locals.eks_endpoint_service_name
  public_vpc_id                     = local.env_vars.locals.public_vpc_id            
  public_cidr_block                 = local.env_vars.locals.public_cidr_block 
  eks_vpc_endpointname              = local.env_vars.locals.eks_vpc_endpointname     
  public_subnet_id                  = local.env_vars.locals.public_subnet_id         
  vpc_keyspacesep                   = local.env_vars.locals.vpc_keyspacesep          
  nlbname                           = local.env_vars.locals.nlbname                  
  acm_certificate                   = local.env_vars.locals.acm_certificate          
  public_subnet_id_1                = local.env_vars.locals.public_subnet_id_1       
  public_subnet_id_2                = local.env_vars.locals.public_subnet_id_2       

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
    source                        = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//EKS"
    version_no                    = "${local.version_no}"
    vpc_id                        = "${local.vpc_id}"
    private_subnet_ids            = ${jsonencode(local.private_subnet_ids)}
    instance_types                = ${jsonencode(local.instance_types)}
    ami_type                      = "${local.ami_type}"
    eks_cluster_name              = "${local.eks_cluster_name}"
    nodename                      = "${local.nodename}"
    desired_size                  = "${local.desired_size}"
    max_size                      = "${local.max_size}"
    min_size                      = "${local.min_size}"
    allowed_cidr_block            = ${jsonencode(local.allowed_cidr_block)}
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
EOF
}
