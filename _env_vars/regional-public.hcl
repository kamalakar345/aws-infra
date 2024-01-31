locals{
# VPC Details
  vpc_id                                  = "vpc-0c6d1887dcc478750"
  private_subnet_ids                      = ["subnet-0f33779d4b8828a68", "subnet-026adba5c45fdb754", "subnet-0c0a6145cf0a2600e"] //privateA and privateB and privateC
  public_subnet_id                        = ["subnet-0b4dfd2607f947004", "subnet-0cae9568bb52f4be6", "subnet-00f7bceb82ef98c24"] // [publicA, publicB, publicC]
  vpc_cidr                                = ["10.166.80.0/22"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.28"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}