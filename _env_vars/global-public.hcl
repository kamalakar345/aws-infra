locals{
# VPC Details
  vpc_id                                  = "vpc-0cfc23d53dd0bc3ee"
  private_subnet_ids                      = ["subnet-06c6d9a88cde1f9fb", "subnet-0c2e2ed2f3f633297"] //privateA and privateB
  public_subnet_id                        = ["subnet-0f974b8f7d42dccc9", "subnet-032d32ba83c5f9bb8"] // [publicA, publicB]
  vpc_cidr                                = ["10.198.174.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.28"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"     
}