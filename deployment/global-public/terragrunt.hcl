locals {
  env = basename(dirname(get_original_terragrunt_dir()))
  component = basename(get_terragrunt_dir())
}

# Include the root terragrunt.hcl
include "common"{
  path = "../common.hcl"
  merge_strategy = "deep"

}


# Including the Public EKS Template
include "public-eks"{
  path = "../../_templates/public-eks.hcl"
  # path = "${get_path_to_repo_root()}/_templates/public-eks.hcl"
  # path = "${get_terragrunt_dir()}/../../../_templates/public-eks.hcl"
  merge_strategy = "deep"
}


# include "private-eks"{
#   # path = "../../../modules/private-EKS/private-eks.hcl"
#   path = "../../_templates/private-eks.hcl"
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

# inputs = {
#   env = local.env
#   # aws_region = "us-east-1"
#   aws_profile_name = "${local.env}_profile"


# # variables for public EKS
#   # public_version_no = "1.24"
#   # public_vpc_id = "my-vpc"
#   # public_vpc_private_subnet_ids = "subnets-ids"
#   # selected = ""
#   # public_ami_type = ""
#   # environment = local.env
#   # public_eks_name = "${local.env}-${local.component}"
#   # public_nodename = local.component
#   # public_ssh_key_name = "${local.env}-${local.component}.pem"
#   # admin_contact = ""
#   # service_id = ""
#   # service_data = ""
#   # public_desired_size = ""
#   # public_max_size = ""
#   # public_min_size = ""
#   # public_cidr_block = ""
#   # public_instance_types = "t2.micro"


# # # variable for private EKS

# #   version_no = 
# #   vpc_id = 
# #   private_subnet_ids = 
# #   selected = 
# #   ami_type = 
# #   instance_types = 
# #   ami_type = 
# #   environment = 
# #   eks_name = 
# #   nodename = 
# #   ssh_key_name = 
# #   admin_contact = 
# #   service_id = 
# #   service_data = 
# #   desired_size = 
# #   max_size = 
# #   min_size = 
# #   private_cidr_block = 


# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   region       = "us-west-2"
#   region_abbr  = "usw2"
#   environment = "reg"
#   admin_contact = "tpscloudops@qti.qualcomm.com"
#   service_id = "AWARE"
#   service_data = "env=reg"
#   aws_profile = "dev"
#   env      = "reg"
#   partition= "reg-priv"
#   purpose = "pt-reg"
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Existing VPC Variables >>>>>>>>>>>>>>>>>>>>>private-2 >>>>>>>regional>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   vpc_id = "vpc-0d1e952fc353044a4"
#   private_cidr_block = ["10.155.174.0/23"]
#   private_subnet_ids = ["subnet-0ffbe443e963d1d98","subnet-086c3785688451a9f"]//privateA and privateB
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EKS Cluster and NodeGroup Creation >>>>>>>Details Private>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   version_no = "1.24"
#   server_purpose = "eks"
#   eks_name = "dev-pentest-reg-priv-eks-cluster"
#   nodename = "workernode"
#   ssh_key_name = "dev_pentest_reg_priv"
#   instance_types = ["m5.large"]
#   ami_type = "AL2_x86_64"
#   desired_size = "4"
#   max_size = "8"
#   min_size = "2"

# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< public EKS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   public_region = "us-west-2"
#   public_region_abbr = "usw2"
#   public_environment = "reg"
#   public_admin_contact = "tpscloudops@qti.qualcomm.com"
#   public_service_id = "AWARE"
#   public_service_data = "env=reg"
#   public_aws_profile = "dev"
#   public_env      = "reg"
#   public_partition= "reg-pub"
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Public-public<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Existing VPC Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   public_vpc_id = "vpc-006fddfb83fd3d82f"
#   public_cidr_block = ["10.155.176.0/23"]
#   public_vpc_private_subnet_ids = ["subnet-0a32febdf57b6c702","subnet-0f6e35a6bfcfc5e96"]
# # #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EKS Cluster and NodeGroup Creation >>>>>>>>>>>>public>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# #   public_version_no = "1.24"
# #   public_server_purpose = "eks"
# #   public_eks_name = "dev-pentest-reg-pub-eks-cluster"
# #   public_nodename = "workernode"
# #   public_ssh_key_name = "dev_pentest_reg_public"
# #   public_instance_types = ["m5.large"]
# #   public_ami_type = "AL2_x86_64"
# #   public_desired_size = "2"
# #   public_max_size = "8"
# #   public_min_size = "2"   
# }


