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