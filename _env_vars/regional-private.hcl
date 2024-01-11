locals{

# VPC Details
  vpc_id                                  = "vpc-085b582d28a0db433"
  vpc_cidr                                = ["10.155.236.0/23"]// First CIDR in the VPC */
  private_subnet_ids                      = ["subnet-03c388ba49e5161f1", "subnet-02fcb314833921a83"] //privateA and privateB
  rds_private_subnet_ids                  = ["subnet-033b559eb3d7e9636", "subnet-0fb187201b0bd9b15"] //privateDB-A and privateDB-B
  //public_subnet_id                        = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [publicA, publicB]
# Keyspace related Configuration

  ## Keyspace Endpoint Related Configs 
  kubernetes_subnet_ids                   = ["subnet-04f7f722225e10c07", "subnet-06836164a44261b65"] // [private-KubernetesA, Private-KubernetesB] since the CNI is enabled it needs to K8s subnet

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.24"       
  instance_types                          = ["c6a.48xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "14"      
  max_size                                = "20"
  min_size                                = "14"     

# Cluster specific variables coming from <env-component>.hcl for RDS Module
  db_instance_class                       = "db.r5.16xlarge"
  db_engine                               = "postgres"
  db_engine_version                       = "14.7"
  db_username                             = "postgressuperuser"
  db_password                             = "P0$tgr3$$up3rus3r12E4"

#Redis Specific Configurations                        
  redis_engine                            = "redis"              
  redis_engine_version                    = "5.0.6"        
  redis_parameter_group_name              = "default.redis5.0"
  redis_instance_type                     = "cache.m5.xlarge"             
  redis_port                              = "6379"                        
  redis_node_count                        = "2"              

#MSK Specific Configurations                                
  msk_kafka_version                       = "2.6.2"
  msk_num_of_broker_nodes                 = "2"
  broker_node_instance_type               = "kafka.m5.4xlarge"
  broker_node_storage_info_volume_size    = "100"
  msk_security_group_ingress_cidr_ipv4    = ["10.0.0.0/8", "100.0.0.0/8"]

##FOR MSK_PRIVATE_LINK
  msk_port                                = "9092"         

##FOR MSK_ENDPOINT In Public VPC
  endpoint_vpc_id                         = "vpc-0c76b4dc1e25ed3cd" // Public VPC-ID
  endpoint_cidr_block                     = ["10.155.238.0/23","10.0.0.0/8", "100.0.0.0/8"]     // Public VPC CIDR
  endpoint_subnet_id                      = ["subnet-0c2648cca42671712", "subnet-012b87380d7c32d63"] // [Public-privateA, Public-privateB] if CNI then it needs to K8s subnet

# EKS Endpoint Specific Configuration           
  eks_port                                    = "443"

## Open Search for DM specific configurations 
  os_instance_type                        = "t3.medium.elasticsearch"
/* ##FOR EKS_ENDPOINT In Public VPC
  endpoint_public_subnet_id               = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [Public-publicA, Public-publicB] */
}