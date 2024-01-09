locals{

# VPC Details
  vpc_id                                  = "vpc-0adff9db11bb6aee0"
  vpc_cidr                                = ["10.166.72.0/22"]
  private_subnet_ids                      = ["subnet-0e30a22a1b92cfc6c", "subnet-0e9d6eb45f0c074c3", "subnet-05332e16c5782142a"] //privateA and privateB and privateC
  rds_private_subnet_ids                  = ["subnet-089bc6972a885c5af", "subnet-05eb7530d268818e5", "subnet-083d7acde92ddb919"] //privateDB-A and privateDB-B and privateDB-C
  //public_subnet_id                        = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [publicA, publicB]
# Keyspace related Configuration

  ## Keyspace Endpoint Related Configs 
  kubernetes_subnet_ids                   = ["subnet-0b09e19d18063286f", "subnet-0dd57e0a628a07887", "subnet-0aa1dfa55961f7561"] // [private-KubernetesA, Private-KubernetesB, Private-KubernetesC] since the CNI is enabled it needs to K8s subnet

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
  endpoint_vpc_id                         = "vpc-0081cf4a7b9561843" // Global Public VPC-ID
  endpoint_cidr_block                     = ["10.166.68.0/22","10.0.0.0/8", "100.0.0.0/8"]     // Public VPC CIDR and qualnet CIDR ranges
  endpoint_subnet_id                      = ["subnet-0b1b662b5e5e0598a", "subnet-01402984a57e38df9", "subnet-0c2fdc9381feac90a"] // [Public-privateA, Public-privateB, Public-privateC]
# EKS Endpoint Specific Configuration           
  eks_port                                    = "443"
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-0d945319e5a0aa311", "subnet-00f8ccdeff7555177"] // [Public-publicA, Public-publicB] */
}