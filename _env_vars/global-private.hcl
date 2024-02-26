locals{

# VPC Details
  vpc_id                                  = "vpc-0e12fd7cddf789df0"
  vpc_cidr                                = ["10.155.224.0/23"]
  private_subnet_ids                      = ["subnet-01361711531df36ea", "subnet-0d93f1226d98c1515"] //privateA and privateB
  rds_private_subnet_ids                  = ["subnet-025367b940c5f2ba4", "subnet-01fb1ad6965ba8a2d"] //privateDB-A and privateDB-B
  //public_subnet_id                        = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [publicA, publicB]
# Keyspace related Configuration

  ## Keyspace Endpoint Related Configs 
  kubernetes_subnet_ids                   = ["subnet-0f5b90ce09860dcde", "subnet-0de391b453928567a"] // [private-KubernetesA, Private-KubernetesB] since the CNI is enabled it needs to K8s subnet

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.24"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "5"
  max_size                                = "8"
  min_size                                = "2"     
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
  endpoint_vpc_id                         = "vpc-0f92311d3fe6dadd0" // Public VPC-ID
  endpoint_cidr_block                     = ["10.198.62.0/23"]     // Public VPC CIDR 
  endpoint_subnet_id                      = ["subnet-05e8d9167e0a807e8", "subnet-0d33f975ef183cd3f"] // [Public-privateA, Public-privateB]
# EKS Endpoint Specific Configuration           
  eks_port                                    = "80"
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [Public-publicA, Public-publicB] */
}