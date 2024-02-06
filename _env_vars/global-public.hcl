locals{
# VPC Details
  vpc_id                                  = "vpc-0bab03f8a8a362ae3"
  private_subnet_ids                      = ["subnet-00d27d96702c74654", "subnet-03d93546de97befc3"] //privateA and privateB
  public_subnet_id                        = ["subnet-01cede1d9f0bfc4f5", "subnet-04080ec7556be4603"] // [publicA, publicB]
  vpc_cidr                                = ["10.155.252.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.26"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}