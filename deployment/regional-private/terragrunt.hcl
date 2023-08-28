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

# Cluster specific variables coming from <env-component>.hcl for RDS Module
  instance_class                    = local.env_vars.locals.instance_class
  database_user                     = local.env_vars.locals.database_user
  db_engine                         = local.env_vars.locals.db_engine
  db_engine_version                 = local.env_vars.locals.db_engine_version
  database_port                     = local.env_vars.locals.database_port
  database_password                 = local.env_vars.locals.database_password     # pass it while applying/planning
  db_identifier                     = local.env_vars.locals.db_identifier
  db_subnet_group_name              = local.env_vars.locals.db_subnet_group_name
  publicly_accessible               = local.env_vars.locals.publicly_accessible //this should be passed as false in case of private .
  rds_private_subnet_ids            = local.env_vars.locals.rds_private_subnet_ids//privateDB-A and privateDB-B

#Redis Specific Configurations                        
  redis_cluster_name                = local.env_vars.locals.redis_cluster_name        
  redis_engine                      = local.env_vars.locals.redis_engine              
  redis_engine_version              = local.env_vars.locals.redis_engine_version      
  redis_parameter_group_name        = local.env_vars.locals.redis_parameter_group_name
  redis_instance_type               = local.env_vars.locals.redis_instance_type       
  redis_port                        = local.env_vars.locals.redis_port                
  redis_node_count                  = local.env_vars.locals.redis_node_count 

#MSK Specific Configurations                                
  cluster_name                      = local.env_vars.locals.cluster_name 
  kafka_version                     = local.env_vars.locals.kafka_version
  broker_nodes                      = local.env_vars.locals.broker_nodes 
  instance_type                     = local.env_vars.locals.instance_type
  storage_info                      = local.env_vars.locals.storage_info 
  sg_name                           = local.env_vars.locals.sg_name          
  subnet_ids                        = local.env_vars.locals.subnet_ids

#Keyspace Spacific Configutration
  keyspace_name                     = local.env_vars.locals.keyspace_name  
  
#Variables for NLB module (For MSK)
  nlb_name                          = local.env_vars.locals.nlb_name            
  port                              = local.env_vars.locals.port                
  target_group_name                 = local.env_vars.locals.target_group_name   
  listener_port                     = local.env_vars.locals.listener_port       
  num_brokers                       = local.env_vars.locals.num_brokers         
  privatelb_subnet_id               = local.env_vars.locals.privatelb_subnet_id 
  privatelb_subnet_id1              = local.env_vars.locals.privatelb_subnet_id1

#MSKPrivatelink_endpoint_service Specific Configutations
  endpoint_service_name             = local.env_vars.locals.endpoint_service_name

#MSKPrivatelink_VPC_endpoint Specific Configuration
  vpc_endpointname                  = local.env_vars.locals.vpc_endpointname
  subnet_id                         = local.env_vars.locals.subnet_id       
  subnet_id1                        = local.env_vars.locals.subnet_id1      
  cidr_block1                       = local.env_vars.locals.cidr_block1  

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
  module "rds" {
    source = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//RDS"
    vpc_id                        = "${local.vpc_id}"
    rds_private_subnet_ids        =  ${jsonencode(local.rds_private_subnet_ids)}
    db_subnet_group_name          = "${local.db_subnet_group_name}"
    instance_class                = "${local.instance_class}"
    database_port                 = "${local.database_port}"
    database_password             = "${local.database_password}"
    db_engine                     = "${local.db_engine}"
    db_engine_version             = "${local.db_engine_version}"
    database_user                 = "${local.database_user}"
    db_identifier                 = "${local.db_identifier}"
    publicly_accessible           = "${local.publicly_accessible}"
}

module "eks" {
    source = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//private-EKS"
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

module "redis" {
    source                        = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//REDIS"
    environment                   = "${local.environment}"
    region                        = "${local.region}"
    vpc_id                        = "${local.vpc_id}"
    redis_cluster_name            = "${local.redis_cluster_name}"
    redis_engine                  = "redis"
    redis_engine_version          = "${local.redis_engine_version}"
    redis_parameter_group_name    = "${local.redis_parameter_group_name}"
    redis_instance_type           = "${local.redis_instance_type}"
    redis_port                    = "${local.redis_port}"
    redis_node_count              = "${local.redis_node_count}"
    admin_contact                 = "${local.admin_contact}"
    service_id                    = "${local.service_id}"
    service_data                  = "${local.service_data}"
    private_subnet_ids            = ${jsonencode(local.private_subnet_ids)}
}

module "msk" {
    source                        = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//MSK"
    cluster_name                  = "${local.cluster_name }"
    kafka_version                 = "${local.kafka_version}"
    broker_nodes                  = "${local.broker_nodes }"
    instance_type                 = "${local.instance_type}"
    storage_info                  = "${local.storage_info }"
    sg_name                       = "${local.sg_name}"
    vpc_id                        = "${local.vpc_id}"
    subnet_ids                    = ${jsonencode(local.subnet_ids)}
 }

module "MSKPrivatelink_nlb" {
    source                        = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//MSK-private-link/nlb"
    nlb_name                      = "${local.nlb_name}"
    vpc_id                        = "${local.vpc_id}"
    port                          = "${local.port}"
    target_group_name             = "${local.target_group_name}"
    listener_port                 = "${local.listener_port}"
    num_brokers                   = "${local.num_brokers}"
    privatelb_subnet_id           = "${local.privatelb_subnet_id}"
    privatelb_subnet_id1          = "${local.privatelb_subnet_id1}"
    cluster_arn                   = module.msk.arn
    depends_on = [
            module.msk
    ]
}

module "keyspace" {
  source                          = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//AWSKeyspaceGlobal"
  keyspace_name                   = "${local.keyspace_name}"
}

module "MSKPrivatelink_endpoint_service" {
    source                        = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//MSK-private-link/endpoint_service"
    vpc_id                        = "${local.vpc_id}"
    network_load_balancer_arns    = [module.MSKPrivatelink_nlb.arn]
    endpoint_service_name         = "${local.endpoint_service_name}"
    depends_on                    = [
            module.MSKPrivatelink_nlb
    ]
}

module "MSKPrivatelink_VPC_endpoint" {
    source                        = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//MSK-private-link/VPC_endpoint"
    service_name                  = module.MSKPrivatelink_endpoint_service.service_name
    vpc_endpointname              = "${local.vpc_endpointname}"
    vpc_id                        = "${local.vpc_id}"
    subnet_id                     = ${jsonencode(local.subnet_id)}
    subnet_id1                    = ${jsonencode(local.subnet_id1)}
    cidr_block                    = ${jsonencode(local.private_cidr_block)}
    cidr_block1                   = ${jsonencode(local.cidr_block1)}
    depends_on                    = [
        module.MSKPrivatelink_endpoint_service
    ]
}

module "ingress-private-nlb" {
    source                        = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//Ingress-private-nlb"
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
    source                        = "github.qualcomm.com:css-aware/aws-infra-terraform-modules.git//EKS-privatelink"
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

