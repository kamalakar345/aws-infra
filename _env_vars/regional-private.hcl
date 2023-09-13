locals{

# VPC Details
  vpc_id                                  = "vpc-0d1e952fc353044a4"
  vpc_cidr                                = ["10.155.186.0/23"]
  private_subnet_ids                      = ["subnet-0424a3be9f4a2dcd1", "subnet-009826ec6d2eacddd"] //privateA and privateB
  rds_private_subnet_ids                  = ["subnet-0df0c1265aed87672", "subnet-01a89421daca3d7e2"] //privateDB-A and privateDB-B

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.24"       
  instance_types                          = ["m5.large"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
  allowed_cidr_block                      = ["10.155.186.0/23"] // First CIDR in the VPC
# Cluster specific variables coming from <env-component>.hcl for RDS Module
  db_instance_class                       = "db.m5.large"
  db_engine                               = "postgres"
  db_engine_version                       = "14.7"
  db_username                             = "postgressuperuser"
  db_password                             = "P0$tgr3$$up3rus3r12E4"

#Redis Specific Configurations                        
  redis_engine                            = "redis"              
  redis_engine_version                    = "5.0.6"        
  redis_parameter_group_name              = "default.redis5.0"
  redis_instance_type                     = "cache.t2.small"               
  redis_port                              = "6379"                        
  redis_node_count                        = "2"              

#MSK Specific Configurations                                
  msk_kafka_version                       = "2.6.2"
  msk_num_of_broker_nodes                 = "2"
  broker_node_instance_type               = "kafka.t3.small"
  broker_node_storage_info_volume_size    = "100"
  msk_security_group_ingress_cidr_ipv4    = ["10.0.0.0/8", "100.0.0.0/8"]

##FOR MSK_PRIVATE_LINK
  msk_port                                = "9092"         

##FOR MSK_ENDPOINT In Public VPC
  endpoint_vpc_id                         = "vpc-006fddfb83fd3d82f" // Public VPC-ID
  endpoint_cidr_block                     = ["10.155.188.0/23"]     // Public VPC CIDR 
  endpoint_subnet_id                      = ["subnet-07ecc7b9ce267f52c", "subnet-0fa79d4c1a0b540fb"] // [Public-privateA, Public-privateB]
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [Public-publicA, Public-publicB] */
# EKS Endpoint Specific Configuration           
  eks_port                                    = "80"
# #ingress-private-nlb Specific Configurations           
#   private_vpc_cidr             
}