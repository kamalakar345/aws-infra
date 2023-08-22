locals {
  # importing the configs <tfvars> both common and cluster specific
  env_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/${basename(get_original_terragrunt_dir())}.hcl")
  common_vars = read_terragrunt_config("${get_path_to_repo_root()}/_env_vars/common_config.hcl")

  env = basename(dirname(get_original_terragrunt_dir()))
  component = basename(get_terragrunt_dir())
# Common variable reference comming from common_config.hcl 
  # vpc              = local.env_vars.locals.vpc

  region                        = local.common_vars.locals.region
  region_abbr                   = local.common_vars.locals.region_abbr
  environment                   = local.common_vars.locals.environment
  admin_contact                 = local.common_vars.locals.admin_contact
  service_id                    = local.common_vars.locals.service_id
  service_data                  = local.common_vars.locals.service_data
  aws_profile                   = local.common_vars.locals.aws_profile
  # env                           = local.common_vars.locals.env


# Cluster specific variables coming from <env-component>.hcl
  public_version_no             = local.env_vars.locals.public_version_no
  public_server_purpose         = local.env_vars.locals.public_server_purpose
  public_eks_name               = local.env_vars.locals.public_eks_name
  public_nodename               = local.env_vars.locals.public_nodename
  # public_ssh_key_name           = local.env_vars.locals.public_ssh_key_name
  public_instance_types         = local.env_vars.locals.public_instance_types
  public_ami_type               = local.env_vars.locals.public_ami_type
  public_desired_size           = local.env_vars.locals.public_desired_size
  public_max_size               = local.env_vars.locals.public_max_size
  public_min_size               = local.env_vars.locals.public_min_size

  public_vpc_id                 = local.env_vars.locals.public_vpc_id
  public_cidr_block             = local.env_vars.locals.public_cidr_block
  public_vpc_private_subnet_ids     = local.env_vars.locals.public_vpc_private_subnet_ids
# Cluster specific variables coming from <env-component>.hcl for RDS Module
  db_instance_class             = local.env_vars.locals.db_instance_class
  db_username                   = local.env_vars.locals.db_username
  db_engine                     = local.env_vars.locals.db_engine
  db_engine_version             = local.env_vars.locals.db_engine_version
  db_password                   = local.env_vars.locals.db_password     # pass it while applying/planning
  db_identifier                 = local.env_vars.locals.db_identifier
  db_subnet_group_name          = local.env_vars.locals.db_subnet_group_name
  publicly_accessible           = local.env_vars.locals.publicly_accessible //this should be passed as false in case of private .
  rds_private_subnet_ids        = local.env_vars.locals.rds_private_subnet_ids//privateDB-A and privateDB-B
  vpc_id                        = local.env_vars.locals.vpc_id
}

# Include the common.hcl
include "common"{
  path = "${get_path_to_repo_root()}/deployment/common.hcl"
  merge_strategy = "deep"

}

generate "main" {
  path      = "main.tf"
  if_exists = "overwrite"
  contents = <<EOF
  module "RDS" {
    source = "${get_repo_root()}/modules/RDS"
    environment                   = "${local.env}"
    region                        = "${local.region}"
    vpc_id                        = "${local.vpc_id}"
    rds_private_subnet_ids        =  ${jsonencode(local.rds_private_subnet_ids)}
    db_subnet_group_name          = "${local.db_subnet_group_name}"
    db_instance_class             = "${local.db_instance_class}"
    db_password                   = "${local.db_password}"
    db_engine                     = "${local.db_engine}"
    db_engine_version             = "${local.db_engine_version}"
    db_username                   = "${local.db_username}"
    db_identifier                 = "${local.db_identifier}"
    publicly_accessible           = "${local.publicly_accessible}"
    admin_contact                 = "${local.admin_contact}"
    service_id                    = "${local.service_id}"
    service_data                  = "${local.service_data}"
}

module "Public-EKS" {
    source = "${get_repo_root()}/modules/public-EKS"
    public_version_no             = "${local.public_version_no}"
    public_vpc_id                 = "${local.public_vpc_id}"
    public_vpc_private_subnet_ids = ${jsonencode(local.public_vpc_private_subnet_ids)}
    environment                   = "${local.environment}"
    public_eks_name               = "${local.public_eks_name}" 
    public_cidr_block             = ${jsonencode(local.public_cidr_block)}
    public_nodename               = "${local.public_nodename}"
    public_instance_types         = ${jsonencode(local.public_instance_types)}
    public_ami_type               = "${local.public_ami_type}"
    public_desired_size           = "${local.public_desired_size}"
    public_max_size               = "${local.public_max_size}"
    public_min_size               = "${local.public_min_size}"
    admin_contact                 = "${local.admin_contact}"
    service_id                    = "${local.service_id}"
    service_data                  = "${local.service_data}"
}

EOF
}




# # Including the Public EKS Template
# include "private-eks"{
#   # path = "../../_templates/public-eks.hcl"
#   path = "${get_path_to_repo_root()}/_templates/${local.component}.hcl"
#   # path = "${get_terragrunt_dir()}/../../../_templates/public-eks.hcl"
#   merge_strategy = "deep"
# }

# # Including the RDS Template
# include "RDS"{
#   # path = "../../../modules/private-EKS/private-eks.hcl"
#   path = "${get_path_to_repo_root()}/_templates/rds.hcl"
#   merge_strategy = "deep"
# }


# dependency "public_eks"{
#   config_path = "../../../modules/public-EKS/public-eks.hcl"

# }


# dependency "private_eks"{
#   config_path = "../../../modules/private-EKS/private-eks.hcl"
# }

/* terraform {


} */
# Input variables for overriding the container profile name
# terraform {
#   modules{
#   private_eks{
#   source = "../../../modules/private-EKS" # Relative path to the "eks" module
#   }
#   }
# }
/* 
include {
  path = "./modules/rds/terragrunt.hcl" # Relative path to the "rds" module
}

include {
  path = "./modules/msk/terragrunt.hcl" # Relative path to the "msk" module
} */

inputs = {
  env = local.env
  # aws_region = "us-east-1"
  aws_profile_name = "${local.env}_profile"


# variables for public EKS
  # public_version_no = "1.24"
  # public_vpc_id = "my-vpc"
  # public_vpc_private_subnet_ids = "subnets-ids"
  # selected = ""
  # public_ami_type = ""
  # environment = local.env
  # public_eks_name = "${local.env}-${local.component}"
  # public_nodename = local.component
  # public_ssh_key_name = "${local.env}-${local.component}.pem"
  # admin_contact = ""
  # service_id = ""
  # service_data = ""
  # public_desired_size = ""
  # public_max_size = ""
  # public_min_size = ""
  # public_cidr_block = ""
  # public_instance_types = "t2.micro"


# # variable for private EKS

#   version_no = 
#   vpc_id = 
#   private_subnet_ids = 
#   selected = 
#   ami_type = 
#   instance_types = 
#   ami_type = 
#   environment = 
#   eks_name = 
#   nodename = 
#   ssh_key_name = 
#   admin_contact = 
#   service_id = 
#   service_data = 
#   desired_size = 
#   max_size = 
#   min_size = 
#   private_cidr_block = 


#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  region       = "us-west-2"
  region_abbr  = "usw2"
  environment = "reg"
  admin_contact = "tpscloudops@qti.qualcomm.com"
  service_id = "AWARE"
  service_data = "env=reg"
  aws_profile = "dev"
  env      = "reg"
  partition= "reg-priv"
  purpose = "pt-reg"
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Existing VPC Variables >>>>>>>>>>>>>>>>>>>>>private-2 >>>>>>>regional>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  vpc_id = "vpc-0d1e952fc353044a4"
  private_cidr_block = ["10.155.174.0/23"]
  private_subnet_ids = ["subnet-0ffbe443e963d1d98","subnet-086c3785688451a9f"]//privateA and privateB
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EKS Cluster and NodeGroup Creation >>>>>>>Details Private>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  version_no = "1.24"
  server_purpose = "eks"
  eks_name = "dev-pentest-reg-priv-eks-cluster"
  nodename = "workernode"
  ssh_key_name = "dev_pentest_reg_priv"
  instance_types = ["m5.large"]
  ami_type = "AL2_x86_64"
  desired_size = "4"
  max_size = "8"
  min_size = "2"

#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< public EKS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  public_region = "us-west-2"
  public_region_abbr = "usw2"
  public_environment = "reg"
  public_admin_contact = "tpscloudops@qti.qualcomm.com"
  public_service_id = "AWARE"
  public_service_data = "env=reg"
  public_aws_profile = "dev"
  public_env      = "reg"
  public_partition= "reg-pub"
#<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Public-public<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Existing VPC Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  public_vpc_id = "vpc-006fddfb83fd3d82f"
  public_cidr_block = ["10.155.176.0/23"]
  public_vpc_private_subnet_ids = ["subnet-0a32febdf57b6c702","subnet-0f6e35a6bfcfc5e96"]
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EKS Cluster and NodeGroup Creation >>>>>>>>>>>>public>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   public_version_no = "1.24"
#   public_server_purpose = "eks"
#   public_eks_name = "dev-pentest-reg-pub-eks-cluster"
#   public_nodename = "workernode"
#   public_ssh_key_name = "dev_pentest_reg_public"
#   public_instance_types = ["m5.large"]
#   public_ami_type = "AL2_x86_64"
#   public_desired_size = "2"
#   public_max_size = "8"
#   public_min_size = "2"   
}


