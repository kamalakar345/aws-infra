locals{
# VPC Details
  vpc_id                                  = "vpc-0ab7f3268a0718551"
  vpc_cidr                                = ["10.197.38.0/23"]// First CIDR in the VPC */
  private_subnet_ids                      = ["subnet-06e4839cc38c5616c", "subnet-0b5a8ddebdca6f07b"] //privateA and privateB
  public_subnet_id                        = ["subnet-061f1532904ceb143", "subnet-0491cba144a686985"] // [publicA, publicB]


# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.28"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}