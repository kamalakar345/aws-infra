locals{
# VPC Details
  vpc_id                                  = "vpc-0f92311d3fe6dadd0"
  private_subnet_ids                      = ["subnet-05e8d9167e0a807e8", "subnet-0d33f975ef183cd3f"] //privateA and privateB
  public_subnet_id                        = ["subnet-0828c39f559d52cff", "subnet-0ff6b748431b8dad4"] // [publicA, publicB]
  vpc_cidr                                = ["10.198.62.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.24"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}