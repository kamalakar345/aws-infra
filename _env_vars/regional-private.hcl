locals{

# VPC Details
  vpc_id                                  = "vpc-0f4a759403cf33bb1"
  vpc_cidr                                = ["10.166.76.0/22"]// First CIDR in the VPC */
  private_subnet_ids                      = ["subnet-0a2a50f785da5a0b1", "subnet-0586625bbae0f5683", "subnet-0c7026c5f8425e030"]//privateA and privateB and privateC
  rds_private_subnet_ids                  = ["subnet-0baf05cf7fd64ee09", "subnet-0f5312a88be26c329", "subnet-075a185972d3fecbf"] //privateDB-A and privateDB-B and privateDB-C
  //public_subnet_id                        = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [publicA, publicB]
# Keyspace related Configuration

  ## Keyspace Endpoint Related Configs 
  kubernetes_subnet_ids                   = ["subnet-03cdaf0b6886dd32c", "subnet-06cef5d406962c7ee", "subnet-031ac7be56a9f9915"] // [private-KubernetesA, Private-KubernetesB] since the CNI is enabled it needs to K8s subnet

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.27"       
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
  msk_num_of_broker_nodes                 = "3"
  broker_node_instance_type               = "kafka.t3.small"
  broker_node_storage_info_volume_size    = "100"
  msk_security_group_ingress_cidr_ipv4    = ["10.0.0.0/8", "100.0.0.0/8"]
  msk_enhanced_monitoring                 = "PER_TOPIC_PER_PARTITION"

##FOR MSK_PRIVATE_LINK
  msk_port                                = "9092"         

##FOR MSK_ENDPOINT In Public VPC
  endpoint_vpc_id                         = "vpc-0c6d1887dcc478750" // Public VPC-ID
  endpoint_cidr_block                     = ["10.166.80.0/22","10.0.0.0/8", "100.0.0.0/8"]     // Public VPC CIDR
  endpoint_subnet_id                      = ["subnet-0f33779d4b8828a68", "subnet-026adba5c45fdb754", "subnet-0c0a6145cf0a2600e"] // [Public-privateA, Public-privateB, Public-privateC ] if CNI then it needs to K8s subnet

# EKS Endpoint Specific Configuration           
  eks_port                                    = "443"

## Open Search for DM specific configurations 
  os_instance_type                        = "t3.medium.elasticsearch"
  availability_zones                      = 3
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-05e4faa1c52b2640c", "subnet-0d30d313f41b49917"] // [Public-publicA, Public-publicB] */
}