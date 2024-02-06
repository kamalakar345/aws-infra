locals{
# VPC Details
  vpc_id                                  = "vpc-0f07b492c52e2a1c2"
  private_subnet_ids                      = ["subnet-0d4cfde020b233610", "subnet-000a49a802c271e8b"] //privateA and privateB
  public_subnet_id                        = ["subnet-0286ac534761f235f", "subnet-03519bd6a6c745713"] // [publicA, publicB]
  vpc_cidr                                = ["10.198.172.0/23"]// First CIDR in the VPC */

# EKS Speicific Configs coming from <env-component>.hcl
  version_no                              = "1.27"       
  instance_types                          = ["c5.2xlarge"]        
  ami_type                                = "AL2_x86_64"
  desired_size                            = "2"      
  max_size                                = "8"
  min_size                                = "2"
}