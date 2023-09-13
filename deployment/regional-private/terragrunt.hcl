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

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = local.env_vars.locals.version_no          
  private_subnet_ids                      = local.env_vars.locals.private_subnet_ids            
  instance_types                          = local.env_vars.locals.instance_types        
  ami_type                                = local.env_vars.locals.ami_type  
  eks_cluster_name                        = "${local.env}-${local.component}-eks"
  desired_size                            = local.env_vars.locals.desired_size      
  max_size                                = local.env_vars.locals.max_size      
  min_size                                = local.env_vars.locals.min_size      
  allowed_cidr_block                      = local.env_vars.locals.allowed_cidr_block
  eks_endpoint_service_tag                = "${local.env}-${local.component}-eks-eps"

# Cluster specific variables coming from <env-component>.hcl for RDS Module
  db_instance_class                       = local.env_vars.locals.db_instance_class     
  db_engine                               = local.env_vars.locals.db_engine             
  db_engine_version                       = local.env_vars.locals.db_engine_version     
  db_username                             = local.env_vars.locals.db_username           
  db_password                             = local.env_vars.locals.db_password           
  db_identifier                           = "${local.env}-${local.component}-rds"         

#Redis Specific Configurations                        
  # redis_cluster_name                      = local.env_vars.locals.redis_cluster_name
  redis_cluster_name                      = "${local.env}-${local.component}-redis"     
  redis_engine                            = local.env_vars.locals.redis_engine              
  redis_engine_version                    = local.env_vars.locals.redis_engine_version      
  redis_parameter_group_name              = local.env_vars.locals.redis_parameter_group_name
  redis_instance_type                     = local.env_vars.locals.redis_instance_type       
  redis_port                              = local.env_vars.locals.redis_port                
  redis_node_count                        = local.env_vars.locals.redis_node_count

#Keyspace Specific Configutration
  keyspace_environment                    = split("-", basename(get_terragrunt_dir()))[0]
  keyspace_component                      = split("-", basename(get_terragrunt_dir()))[1]
  keyspace_name                           = "${local.env}_${local.keyspace_environment}_${local.keyspace_component}_keyspace"
#MSK Specific Configurations                                
  # cluster_name                            = local.env_vars.locals.cluster_name                                     
  msk_cluster_name                        = "${local.env}-${local.component}-msk"                    
  msk_kafka_version                       = local.env_vars.locals.msk_kafka_version                   
  msk_num_of_broker_nodes                 = local.env_vars.locals.msk_num_of_broker_nodes             
  broker_node_instance_type               = local.env_vars.locals.broker_node_instance_type           
  broker_node_storage_info_volume_size    = local.env_vars.locals.broker_node_storage_info_volume_size
  msk_security_group_ingress_cidr_ipv4    = local.env_vars.locals.msk_security_group_ingress_cidr_ipv4
##FOR MSK_PRIVATE_LINK
  msk_nlb_name                            = "${local.env}-${local.component}-msk-nlb"
  msk_port                                = local.env_vars.locals.msk_port         

##FOR MSK_ENDPOINT In Public VPC
  endpoint_vpc_id                         = local.env_vars.locals.endpoint_vpc_id
  endpoint_cidr_block                     = local.env_vars.locals.endpoint_cidr_block
  endpoint_subnet_id                      = local.env_vars.locals.endpoint_subnet_id          
  vpc_endpoint_tag                        = "${local.env}-${local.component}-msk-ep"

##ACM Specific Configuration
  domain                                  = "aware-${local.env}-${local.component}.qualcomm.com"

# EKS Endpoint Specific Configuration           
  eks_vpc_endpoint_tag                    = "${local.env}-${split("-", "${local.component}")[0]}-public-eks-ep"
  eks_port                                = local.env_vars.locals.eks_port   
# #ingress-private-nlb Specific Configurations           
#   private_vpc_cidr                        = local.env_vars.locals.private_vpc_cidr       
#   private_acm_certificate                 = local.env_vars.locals.private_acm_certificate
#   privatesubnetids                        = local.env_vars.locals.privatesubnetids       
#   private_DNS                             = local.env_vars.locals.private_DNS            

# # "EKS-privatelink" Specific Configurations
#   eks_endpoint_service_name               = local.env_vars.locals.eks_endpoint_service_name
#   public_vpc_id                           = local.env_vars.locals.public_vpc_id            
#   public_cidr_block                       = local.env_vars.locals.public_cidr_block        
#   eks_vpc_endpointname                    = local.env_vars.locals.eks_vpc_endpointname     
#   public_subnet_id                        = local.env_vars.locals.public_subnet_id         
#   vpc_keyspacesep                         = local.env_vars.locals.vpc_keyspacesep          
#   nlbname                                 = local.env_vars.locals.nlbname                  
#   acm_certificate                         = local.env_vars.locals.acm_certificate          
#   public_subnet_id_1                      = local.env_vars.locals.public_subnet_id_1       
#   public_subnet_id_2                      = local.env_vars.locals.public_subnet_id_2       

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
    allowed_cidr_block                    = ${jsonencode(local.allowed_cidr_block)}
    domain                                = "${local.domain}"
    vpc_cidr                              = ${jsonencode(local.vpc_cidr)}
    endpoint_service_tag                  = "${local.eks_endpoint_service_tag}"
    exsiting_lb                           = true
    aws_account                           = ${local.aws_account}
    depends_on                            = [ module.ACM ]
}

module "rds" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//RDS"
    vpc_id                                = "${local.vpc_id}"
    rds_private_subnet_ids                = ${jsonencode(local.private_subnet_ids)}
    db_instance_class                     = "${local.db_instance_class}"     
    db_engine                             = "${local.db_engine}"  
    db_engine_version                     = "${local.db_engine_version}"    
    db_username                           = "${local.db_username}"  
    db_password                           = "${local.db_password}"  
    db_identifier                         = "${local.db_identifier}"
}

module "redis" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//REDIS"
    vpc_id                                = "${local.vpc_id}"
    redis_private_subnet_ids              = ${jsonencode(local.private_subnet_ids)}
    redis_cluster_name                    = "${local.redis_cluster_name}"            
    redis_engine                          = "${local.redis_engine}"       
    redis_engine_version                  = "${local.redis_engine_version}"            
    redis_parameter_group_name            = "${local.redis_parameter_group_name}"   
    redis_instance_type                   = "${local.redis_instance_type}"   
    redis_port                            = "${local.redis_port}"   
    redis_node_count                      = "${local.redis_node_count}"
}

module "keyspace" {
  source                                  = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//Keyspace"
  keyspace_name                           = "${local.keyspace_name}"
}

module "msk" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//MSK"
    vpc_id                                = "${local.vpc_id}"
    broker_node_subnets                   = ${jsonencode(local.private_subnet_ids)}
    msk_cluster_name                      = "${local.msk_cluster_name}"
    msk_kafka_version                     = "${local.msk_kafka_version}"
    msk_num_of_broker_nodes               = "${local.msk_num_of_broker_nodes}"
    broker_node_instance_type             = "${local.broker_node_instance_type}"
    broker_node_storage_info_volume_size  = "${local.broker_node_storage_info_volume_size}"
    msk_security_group_ingress_cidr_ipv4  = ${jsonencode(local.msk_security_group_ingress_cidr_ipv4)}

##FOR MSK_PRIVATE_LINK
    privatelink_subnet_id                 = ${jsonencode(local.private_subnet_ids)}
    nlb_name                              = "${local.msk_nlb_name}"
    port                                  = "${local.msk_port}"

##FOR MSK_ENDPOINT
    endpoint_vpc_id                       = "${local.endpoint_vpc_id}"
    endpoint_cidr_block                   = ${jsonencode(local.endpoint_cidr_block)}
    endpoint_subnet_id                    = ${jsonencode(local.endpoint_subnet_id)}
    vpc_endpoint_tag                      = "${local.vpc_endpoint_tag}"

 }

 module "ACM" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//ACM"
    domain                                = "${local.domain}"
  }

module "eks_endpoint"{
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//endpoint"
    endpoint_vpc_id                       = "${local.endpoint_vpc_id}"
    endpoint_cidr_block                   = ${jsonencode(local.endpoint_cidr_block)}
    endpoint_subnet_id                    = ${jsonencode(local.endpoint_subnet_id)}
    /* endpoint_subnet_id                    = {jsonencode(local.endpoint_public_subnet_id)} */
    /* endpoint_service_name                 = data.aws_vpc_endpoint_service.eks_eps.service_name */
    endpoint_service_name                 = module.eks.eps_service_name
    vpc_endpoint_tag                      = "${local.eks_vpc_endpoint_tag}"     
    port                                  = "${local.eks_port}"
    depends_on                            = [ module.eks ]               
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

  output "MSK" {
      value = module.msk
  }

  output "keyspace" {
      value = module.keyspace
  }
  output "ACM" {
      value = module.ACM
  }
  output "eks_ep" {
    value = module.eks_endpoint
  }

EOF
}

