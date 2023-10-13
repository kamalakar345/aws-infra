locals{
# VPC Details
  vpc_id                                  = "vpc-09ee7634b8fcfc251"
  private_subnet_ids                      = ["subnet-0b1812b1bb3be4c75", "subnet-0d2d487515ababff7"] //privateA and privateB
  public_subnet_id                        = ["subnet-05e4faa1c52b2640c", "subnet-0d30d313f41b49917"] // [publicA, publicB]
  vpc_cidr                                = ["10.155.246.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.24"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}