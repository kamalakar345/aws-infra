locals{

# VPC Details
  vpc_id                                  = "vpc-0084581b793982642"
  vpc_cidr                                = ["10.198.148.0/23"]// First CIDR in the VPC */
  private_subnet_ids                      = ["subnet-0ec0bea2b55682148", "subnet-010e90bafe170d2c9"]//privateA and privateB
  rds_private_subnet_ids                  = ["subnet-00921d4b51652ae37", "subnet-03528fd2cc8dde0bc"] //privateDB-A and privateDB-B
  //public_subnet_id                        = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [publicA, publicB]
# Keyspace related Configuration

  ## Keyspace Endpoint Related Configs 
  kubernetes_subnet_ids                   = ["subnet-09c60db1d64b9e752", "subnet-0001d95edc842fcc7"] // [private-KubernetesA, Private-KubernetesB] since the CNI is enabled it needs to K8s subnet

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
  endpoint_vpc_id                         = "vpc-0f07b492c52e2a1c2" // Public VPC-ID
  endpoint_cidr_block                     = ["10.198.172.0/23", "100.0.0.0/8"]     // Public VPC CIDR
  endpoint_subnet_id                      = ["subnet-0d4cfde020b233610", "subnet-000a49a802c271e8b"] // [Public-privateA, Public-privateB] if CNI then it needs to K8s subnet

# EKS Endpoint Specific Configuration           
  eks_port                                    = "443"

## Open Search for DM specific configurations 
  os_instance_type                        = "t3.medium.elasticsearch"
  availability_zones                      = 3
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-0286ac534761f235f", "subnet-03519bd6a6c745713"] // [Public-publicA, Public-publicB] */
}