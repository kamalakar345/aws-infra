locals{
# VPC Details
  vpc_id                                  = "vpc-073355ca2b946aa10"
  private_subnet_ids                      = ["subnet-0b87894020d4d723c", "subnet-019043f82688bcba4"] //privateA and privateB
  public_subnet_id                        = ["subnet-0d945319e5a0aa311", "subnet-00f8ccdeff7555177"] // [publicA, publicB]
  vpc_cidr                                = ["10.166.6.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.28"
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}