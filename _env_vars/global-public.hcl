locals{
# VPC Details
  vpc_id                                  = "vpc-0081cf4a7b9561843"
  private_subnet_ids                      = ["subnet-0b1b662b5e5e0598a", "subnet-01402984a57e38df9", "subnet-0c2fdc9381feac90a"] //privateA and privateB and privateC
  public_subnet_id                        = ["subnet-07f31d2e4968b0b21", "subnet-04cd8974e516cee26", "subnet-04d92fe049ca6320d"] // [publicA, publicB, publicC]
  vpc_cidr                                = ["10.166.68.0/22"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.26"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}