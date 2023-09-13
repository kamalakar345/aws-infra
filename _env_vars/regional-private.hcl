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
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Common Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   region       = "us-west-2"
#   region_abbr  = "usw2"
#   environment = "reg"
#   admin_contact = "tpscloudops@qti.qualcomm.com"
#   service_id = "AWARE"
#   service_data = "env=reg"
#   aws_profile = "dev"
#   env      = "reg"
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Existing VPC Variables >>>>>>>>>>>>>>>>>>>>>private-2 >>>>>>>regional>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   vpc_id = "vpc-0d1e952fc353044a4"
#   private_cidr_block = ["10.155.174.0/23"]
#   private_subnet_ids = ["subnet-0ffbe443e963d1d98","subnet-086c3785688451a9f"]//privateA and privateB
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EKS Cluster and NodeGroup Creation >>>>>>>Details Private>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   version_no = "1.24"
#   server_purpose = "eks"
#   eks_name = "dev-pentest-reg-priv-eks-cluster"
#   nodename = "workernode"
#   instance_types = ["m5.large"]
#   ami_type = "AL2_x86_64"
#   desired_size = "4"
#   max_size = "8"
#   min_size = "2"
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< RDS Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   database_port = 5432
#   instance_class = "db.m5.large"
#   database_user = "postgressuperuser" 
#   db_engine = "postgres"
#   db_engine_version = "14.7"
#   database_password = "P0$tgr3$$up3rus3r12E4"     # pass it while applying/planning
#   db_identifier = "dev-pentest-reg-priv-new-rds-database-psql"
#   db_subnet_group_name = "dev-pentest-reg-priv-rds-subnet"
#   publicly_accessible = false //this should be passed as false in case of private .
#   rds_private_subnet_ids = ["subnet-0f2ad0ca73651e01c","subnet-04c27f148a064e8fe"]//privateDB-A and privateDB-B
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< REDIS CACHE Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   redis_cluster_name = "dev-pentest-reg-priv-redis"
#   redis_engine = "redis"
#   redis_engine_version = "5.0.6"
#   redis_parameter_group_name = "default.redis5.0"
#   redis_instance_type = "cache.t2.small"
#   redis_port = 6379
#   redis_node_count = 2
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<< MSK >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   cluster_name = "dev-pentest-reg-priv"
#   kafka_version = "2.6.2"
#   broker_nodes =  2
#   instance_type = "kafka.t3.small"
#   storage_info  = 100
#   sg_name = ""
#   subnet_ids = ["subnet-0ffbe443e963d1d98", "subnet-086c3785688451a9f"]  //privateA and privateB
# #<<<<<<<<<<<<<<<<<<<<< AWSKeyspace >>>>>>>>>>>>>>>>>>
#   keyspace_name = "dev_pentest_reg"
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< msk private link >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   nlb_name = "dev-pentest-reg-priv-nlb"
#   port = 9092
#   target_group_name = "dev-pentest-reg-priv-nlb-TG"
#   listener_port = 9092
#   num_brokers = 2
#   endpoint_service_name = "dev-pentest-reg-priv-sg_name"
#   vpc_endpointname = "dev-pentest-reg-priv-ept"
#   subnet_id = "subnet-0a32febdf57b6c702" // public-private-subnetA 
#   subnet_id1 = "subnet-0f6e35a6bfcfc5e96" // public-private-subnetB
#   cidr_block = ["10.155.176.0/25"]
#   cidr_block1 = ["10.155.176.128/25"]
#   privatelb_subnet_id = "subnet-0ffbe443e963d1d98"  //privateA 
#   privatelb_subnet_id1 = "subnet-086c3785688451a9f"  //privateB
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
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<Public-public<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Existing VPC Variables >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   public_vpc_id = "vpc-0d1e952fc353044a4"
#   public_cidr_block = ["10.155.176.0/23"]
#   public_vpc_private_subnet_ids = ["subnet-0a32febdf57b6c702", "subnet-0f6e35a6bfcfc5e96"]
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EKS Cluster and NodeGroup Creation >>>>>>>>>>>>public>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   public_version_no = "1.24"
#   public_server_purpose = "eks"
#   public_eks_name = "dev-pentest-reg-pub-eks-cluster"
#   public_nodename = "workernode"
#   public_ssh_key_name = "dev_pentest_reg_public"
#   public_instance_types = ["m5.large"]
#   public_ami_type = "AL2_x86_64"
#   public_desired_size = "2"
#   public_max_size = "8"
#   public_min_size = "2"   
# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Ingress-NLB-Priv>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   private_vpc_cidr = "10.155.174.0/23"  #private
#   private_acm_certificate  = "arn:aws:acm:us-west-2:348432257882:certificate/7a372d79-a412-4d5e-ab58-d33180a70ca6"
#   privatesubnetids = "subnet-0ffbe443e963d1d98, subnet-086c3785688451a9f"  # private-private
#   private_DNS =  "dev-pentest-reg.aware-dev.qualcomm.com" 
# ##<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Ingress-NLB-Pub>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   public_vpc_cidr = "10.155.176.0/23"
#   public_acm_certificate  = "arn:aws:acm:us-west-2:348432257882:certificate/7a372d79-a412-4d5e-ab58-d33180a70ca6"
#   publicsubnetids = "subnet-0f9dbd43bec1546b2, subnet-061c56c3e8d66afce" #public public
#   public_DNS = "dev-pentest-regional.aware-dev.qualcomm.com"

# #<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< EKS priv link >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#   eks_endpoint_service_name = "dev-pentest-reg-eksendpoint-service"
#   public_subnet_id = ["subnet-0f9dbd43bec1546b2", "subnet-061c56c3e8d66afce"]
#   eks_vpc_endpointname = "dev-pentest-reg-eks-endpoint"
#   public_subnet_id_1 = ["subnet-0f9dbd43bec1546b2"] 
#   public_subnet_id_2 = ["subnet-061c56c3e8d66afce"]
#   vpc_keyspacesep = "dev-pentest-reg-keyspaces-endpoint"
#   nlbname = "dev-pentest-reg-internal"
#   acm_certificate = "arn:aws:acm:us-west-2:348432257882:certificate/7a372d79-a412-4d5e-ab58-d33180a70ca6"



}