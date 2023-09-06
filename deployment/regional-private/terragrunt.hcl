locals {
  # importing the configs <tfvars> both common and cluster specific
  env_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/${basename(get_original_terragrunt_dir())}.hcl")
  common_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/common_config.hcl")

  env = basename(dirname(get_original_terragrunt_dir()))
  component = basename(get_terragrunt_dir())

# Common variable reference comming from common_config.hcl 
  region                                  = local.common_vars.locals.region
  region_abbr                             = local.common_vars.locals.region_abbr
  environment                             = local.common_vars.locals.environment
  admin_contact                           = local.common_vars.locals.admin_contact
  service_id                              = local.common_vars.locals.service_id
  service_data                            = local.common_vars.locals.service_data
  aws_profile                             = local.common_vars.locals.aws_profile

# Common Network Configuration Details
  vpc_id                                  = local.env_vars.locals.vpc_id

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = local.env_vars.locals.version_no          
  private_subnet_ids                      = local.env_vars.locals.private_subnet_ids            
  instance_types                          = local.env_vars.locals.instance_types        
  ami_type                                = local.env_vars.locals.ami_type  
  # eks_cluster_name                        = local.env_vars.locals.eks_cluster_name
  eks_cluster_name                        = "${local.env}-${local.component}-eks"
  nodename                                = "${local.env}-${local.component}-nodes"
  desired_size                            = local.env_vars.locals.desired_size      
  max_size                                = local.env_vars.locals.max_size      
  min_size                                = local.env_vars.locals.min_size      
  allowed_cidr_block                      = local.env_vars.locals.allowed_cidr_block

# Cluster specific variables coming from <env-component>.hcl for RDS Module
  rds_private_subnet_ids                  = local.env_vars.locals.rds_private_subnet_ids
  db_instance_class                       = local.env_vars.locals.db_instance_class     
  db_engine                               = local.env_vars.locals.db_engine             
  db_engine_version                       = local.env_vars.locals.db_engine_version     
  db_username                             = local.env_vars.locals.db_username           
  db_password                             = local.env_vars.locals.db_password           
  db_identifier                           = local.env_vars.locals.db_identifier         

#Redis Specific Configurations                        
  redis_private_subnet_ids                = local.env_vars.locals.redis_private_subnet_ids
  # redis_cluster_name                      = local.env_vars.locals.redis_cluster_name
  redis_cluster_name                      = "${local.env}-${local.component}-redis"     
  redis_engine                            = local.env_vars.locals.redis_engine              
  redis_engine_version                    = local.env_vars.locals.redis_engine_version      
  redis_parameter_group_name              = local.env_vars.locals.redis_parameter_group_name
  redis_instance_type                     = local.env_vars.locals.redis_instance_type       
  redis_port                              = local.env_vars.locals.redis_port                
  redis_node_count                        = local.env_vars.locals.redis_node_count

#Keyspace Spacific Configutration
  # keyspace_name                           = local.env_vars.locals.keyspace_name 
  keyspace_name                           = "${local.env}-${local.component}-keyspace"
#MSK Specific Configurations                                
  # cluster_name                            = local.env_vars.locals.cluster_name 
  cluster_name                            = "${local.env}-${local.component}-msk"
  kafka_version                           = local.env_vars.locals.kafka_version
  broker_nodes                            = local.env_vars.locals.broker_nodes 
  instance_type                           = local.env_vars.locals.instance_type
  storage_info                            = local.env_vars.locals.storage_info 
  sg_name                                 = local.env_vars.locals.sg_name          
  subnet_ids                              = local.env_vars.locals.subnet_ids

##FOR MSK_PRIVATE_LINK
  subnet_id                             = local.env_vars.locals.private_link_subnet_ids
  endpoint_service_tag                  = "${local.env}-${local.component}-msk-eps"
  nlb_name                              = "${local.env}-${local.component}-msk-nlb"
  num_brokers                           = local.env_vars.msk_num_of_broker_nodes 
  port                                  = local.env_vars.locals.port         
  target_ips                            = local.env_vars.locals.target_ips

##FOR MSK_ENDPOINT In Public VPC
  endpoint_vpc_id                       = local.env_vars.locals.endpoint_vpc_id
  endpoint_cidr_block                   = local.env_vars.locals.endpoint_cidr_block
  endpoint_subnet_id                    = local.env_vars.locals.endpoint_subnet_id          
  vpc_endpoint_tag                      = "${local.env}-${local.component}-msk-ep"

#ingress-private-nlb Specific Configurations           
  private_vpc_cidr                        = local.env_vars.locals.private_vpc_cidr       
  private_acm_certificate                 = local.env_vars.locals.private_acm_certificate
  privatesubnetids                        = local.env_vars.locals.privatesubnetids       
  private_DNS                             = local.env_vars.locals.private_DNS            

# "EKS-privatelink" Specific Configurations
  eks_endpoint_service_name               = local.env_vars.locals.eks_endpoint_service_name
  public_vpc_id                           = local.env_vars.locals.public_vpc_id            
  public_cidr_block                       = local.env_vars.locals.public_cidr_block        
  eks_vpc_endpointname                    = local.env_vars.locals.eks_vpc_endpointname     
  public_subnet_id                        = local.env_vars.locals.public_subnet_id         
  vpc_keyspacesep                         = local.env_vars.locals.vpc_keyspacesep          
  nlbname                                 = local.env_vars.locals.nlbname                  
  acm_certificate                         = local.env_vars.locals.acm_certificate          
  public_subnet_id_1                      = local.env_vars.locals.public_subnet_id_1       
  public_subnet_id_2                      = local.env_vars.locals.public_subnet_id_2       

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
    nodename                              = "${local.nodename}"
    desired_size                          = "${local.desired_size}"
    max_size                              = "${local.max_size}"
    min_size                              = "${local.min_size}"
    allowed_cidr_block                    = ${jsonencode(local.allowed_cidr_block)}
}

module "rds" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//RDS"
    vpc_id                                = "${local.vpc_id}"
    rds_private_subnet_ids                = ${jsonencode(local.rds_private_subnet_ids)}
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
    redis_private_subnet_ids              = ${jsonencode(local.redis_private_subnet_ids)}
    redis_cluster_name                    = "${local.redis_cluster_name}"            
    redis_engine                          = "${local.redis_engine}"       
    redis_engine_version                  = "${local.redis_engine_version}"            
    redis_parameter_group_name            = "${local.redis_parameter_group_name}"   
    redis_instance_type                   = "${local.redis_instance_type}"   
    redis_port                            = "${local.redis_port}"   
    redis_node_count                      = "${local.redis_node_count}"
}

module "keyspace" {
  source                                  = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//AWSKeyspace"
  keyspace_name                           = "${local.keyspace_name}"
}

module "msk" {
    source                                = "git@github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//MSK"
    vpc_id                                = "${local.vpc_id}"
    broker_node_subnets                   = ${jsonencode(local.broker_node_subnets)}
    msk_cluster_name                      = "${local.msk_cluster_name}"
    msk_kafka_version                     = "${local.msk_kafka_version}"
    msk_num_of_broker_nodes               = "${local.msk_num_of_broker_nodes}"
    broker_node_instance_type             = "${local.broker_node_instance_type}"
    broker_node_storage_info_volume_size  = "${local.broker_node_storage_info_volume_size}"
    msk_security_group_ingress_cidr_ipv4  = ${jsonencode(local.msk_security_group_ingress_cidr_ipv4)}

##FOR MSK_PRIVATE_LINK
    subnet_id                             = ${jsonencode(local.subnet_id)}
    endpoint_service_tag                  = "${local.endpoint_service_tag}"
    nlb_name                              = "${local.nlb_name}"
    num_brokers                           = "${local.msk_num_of_broker_nodes}" 
    port                                  = "${local.port}" 
    target_ips                            = ${jsonencode(local.target_ips)}

##FOR MSK_ENDPOINT
    endpoint_vpc_id                       = "${local.endpoint_vpc_id}"
    endpoint_cidr_block                   = ${jsonencode(local.endpoint_cidr_block)}
    endpoint_subnet_id                    = ${jsonencode(local.endpoint_subnet_id)}
    vpc_endpoint_tag                      = "${local.vpc_endpoint_tag}"

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

EOF
}

