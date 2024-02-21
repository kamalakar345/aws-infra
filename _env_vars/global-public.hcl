locals{
# VPC Details
  vpc_id                                  = "vpc-03d8ca1ae57e06cb1"
  vpc_cidr                                = ["10.155.240.0/23"]// First CIDR in the VPC */
  private_subnet_ids                      = ["subnet-012c9a9a6ba42d91b", "subnet-0c39d78683642f719"] //privateA and privateB
  public_subnet_id                        = ["subnet-0fd28108cd25e589c", "subnet-070fcc5d03b56405b"] // [publicA, publicB]


# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.28"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}