locals{

# VPC Details
  vpc_id                                  = "vpc-09880462f53024971"
  vpc_cidr                                = ["10.155.242.0/23"]
  private_subnet_ids                      = ["subnet-0f84a41f151e57595", "subnet-0b3f58f8aab5f33a1"] //privateA and privateB
  rds_private_subnet_ids                  = ["subnet-04744fd2797e9aa40", "subnet-03dcafaa1b699015f"] //privateDB-A and privateDB-B
# Keyspace related Configuration

  ## Keyspace Endpoint Related Configs 
  kubernetes_subnet_ids                   = ["subnet-0dd5ffc20b56556d9", "subnet-0dccabb0263d6feb3"] // [private-KubernetesA, Private-KubernetesB] since the CNI is enabled it needs to K8s subnet

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.28"       
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
  msk_enhanced_monitoring                 = "PER_TOPIC_PER_PARTITION"

##FOR MSK_PRIVATE_LINK
  msk_port                                = "9092"         

##FOR MSK_ENDPOINT In Public VPC
  endpoint_vpc_id                         = "vpc-03d8ca1ae57e06cb1" // Public VPC-ID
  endpoint_cidr_block                     = ["10.155.240.0/23"]     // Public VPC CIDR 
  endpoint_subnet_id                      = ["subnet-012c9a9a6ba42d91b", "subnet-0c39d78683642f719"] // [Public-privateA, Public-privateB]
# EKS Endpoint Specific Configuration           
  eks_port                                    = "443"
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [Public-publicA, Public-publicB] */
}