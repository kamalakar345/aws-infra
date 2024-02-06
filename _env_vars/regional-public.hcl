locals{
# VPC Details
  vpc_id                                  = "vpc-0c76b4dc1e25ed3cd"
  private_subnet_ids                      = ["subnet-0c2648cca42671712", "subnet-012b87380d7c32d63"] //privateA and privateB
  public_subnet_id                        = ["subnet-0e7aa6653c089e78d", "subnet-066c3e8b6b449d60e"] // [publicA, publicB]
  vpc_cidr                                = ["10.155.238.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.26"       
  instance_types                          = ["c5.24xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}