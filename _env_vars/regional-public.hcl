locals{
# VPC Details
  vpc_id                                  = "vpc-006fddfb83fd3d82f"
  private_subnet_ids                      = ["subnet-07ecc7b9ce267f52c", "subnet-0fa79d4c1a0b540fb"] //privateA and privateB
  public_subnet_id                        = ["subnet-0b9c81b616f6d4dd5", "subnet-0c442e7a570e01d2c"] // [publicA, publicB]
  vpc_cidr                                = ["10.155.188.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.24"       
  instance_types                          = ["m5.large"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}