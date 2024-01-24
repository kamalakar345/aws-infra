locals{

# VPC Details
  vpc_id                                  = "vpc-06b5a0014044ee4aa"
  vpc_cidr                                = ["10.166.0.0/23"]// First CIDR in the VPC */
  private_subnet_ids                      = ["subnet-09aa3a9354da74d9c", "subnet-00ab87025981519d4"] //privateA and privateB
  rds_private_subnet_ids                  = ["subnet-0952b8657af26ddf5", "subnet-0cc0414b560ff1ee4"] //privateDB-A and privateDB-B
  //public_subnet_id                        = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [publicA, publicB]
# Keyspace related Configuration

  ## Keyspace Endpoint Related Configs 
  kubernetes_subnet_ids                   = ["subnet-02d697cd9cf55661e", "subnet-053b4480a8832e076"] // [private-KubernetesA, Private-KubernetesB] since the CNI is enabled it needs to K8s subnet

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
  msk_enhanced_monitoring                 = "PER_TOPIC_PER_PARTITION"

##FOR MSK_PRIVATE_LINK
  msk_port                                = "9092"         

##FOR MSK_ENDPOINT In Public VPC
  endpoint_vpc_id                         = "vpc-09ee7634b8fcfc251" // Public VPC-ID
  endpoint_cidr_block                     = ["10.155.246.0/23","10.0.0.0/8", "100.0.0.0/8"]     // Public VPC CIDR
  endpoint_subnet_id                      = ["subnet-0b1812b1bb3be4c75", "subnet-0d2d487515ababff7"] // [Public-privateA, Public-privateB] if CNI then it needs to K8s subnet

# EKS Endpoint Specific Configuration           
  eks_port                                    = "443"

## Open Search for DM specific configurations 
  os_instance_type                        = "t3.medium.elasticsearch"
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-05e4faa1c52b2640c", "subnet-0d30d313f41b49917"] // [Public-publicA, Public-publicB] */
}