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
  server_purpose                    = local.env_vars.locals.server_purpose
  eks_name                          = local.env_vars.locals.eks_name
  nodename                          = local.env_vars.locals.nodename
  instance_types                    = local.env_vars.locals.instance_types
  ami_type                          = local.env_vars.locals.ami_type
  desired_size                      = local.env_vars.locals.desired_size
  max_size                          = local.env_vars.locals.max_size
  min_size                          = local.env_vars.locals.min_size
  vpc_id                            = local.env_vars.locals.vpc_id
  private_cidr_block                = local.env_vars.locals.private_cidr_block
  private_subnet_ids                = local.env_vars.locals.private_subnet_ids

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
    source = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//EKS"
    environment                   = "${local.environment}"
    version_no                    = "${local.version_no}"
    vpc_id                        = "${local.vpc_id}"
    private_subnet_ids            = ${jsonencode(local.private_subnet_ids)}
    eks_name                      = "${local.eks_name}" 
    private_cidr_block            = ${jsonencode(local.private_cidr_block)}
    nodename                      = "${local.nodename}"
    instance_types                = ${jsonencode(local.instance_types)}
    ami_type                      = "${local.ami_type}"
    desired_size                  = "${local.desired_size}"
    max_size                      = "${local.max_size}"
    min_size                      = "${local.min_size}"
    admin_contact                 = "${local.admin_contact}"
    service_id                    = "${local.service_id}"
    service_data                  = "${local.service_data}"
}


module "ingress-private-nlb" {
    source                        = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//Ingress-private-nlb"
    eks_name                      = "${local.eks_name}"
    environment                   = "${local.environment}"
    region                        = "${local.region}"
    private_vpc_cidr              = ${jsonencode(local.private_vpc_cidr)}
    private_acm_certificate       = "${local.private_acm_certificate}"
    privatesubnetids              = ${jsonencode(local.privatesubnetids)}
    private_DNS                   = "${local.private_DNS}"
    depends_on                    = [module.eks]
}

resource "time_sleep" "wait_for_lb" {
    create_duration               = "600s"
    depends_on                    = [module.ingress-private-nlb]
}

data "aws_lb" "load_balancer" {
  tags = {
      environment                 = "${local.environment}"
  }
  depends_on                      = [module.ingress-private-nlb, time_sleep.wait_for_lb]
}

module "EKS-privatelink" {
    source                        = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//EKS-privatelink"
    network_load_balancer_arns    = data.aws_lb.load_balancer.arn
    eks_endpoint_service_name     = "${local.eks_endpoint_service_name}"
    public_vpc_id                 = "${local.public_vpc_id}"
    public_cidr_block             = ${jsonencode(local.public_cidr_block)}
    eks_vpc_endpointname          = "${local.eks_vpc_endpointname}"
    public_subnet_id              = ${jsonencode(local.public_subnet_id)}
    region                        = "${local.region}"
    vpc_keyspacesep               = "${local.vpc_keyspacesep}"
    nlbname                       = "${local.nlbname}"
    acm_certificate               = "${local.acm_certificate}"
    public_subnet_id_1            = ${jsonencode(local.public_subnet_id_1)}
    public_subnet_id_2            = ${jsonencode(local.public_subnet_id_2)}
    depends_on                    = [module.ingress-private-nlb]
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
  
  output "RDS" {
      value = module.rds
  }
  
  output "REDIS" {
      value = module.redis
  }
  
  output "public_EKS"{
      value = module.eks
  }

EOF
}
