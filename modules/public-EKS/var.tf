 variable "public_version_no" {
  description = "version of the eks cluster"
  type    = string
 }
variable "public_vpc_id" {
  description = "VPC ID of the env"
  type    = string
 }
#  variable "public_vpc_public_subnet_ids" {
#   description = "Mention 2 Subnet ID's"
#   type    = list
# }
variable "public_vpc_private_subnet_ids" {
  description = "Mention 2 Subnet ID's"
  type    = list(string)
}
data "aws_vpc" "selected" {
  id = var.public_vpc_id
  # type = string
 }
 variable "public_instance_types" {
  description = "Mention instance types"
  type    = list(string)
}
variable "public_ami_type" {
  description = "Mention 2 Subnet ID's"
  type = string 
}
variable "environment" {
  description = "The environment like dev,qa,prod, dev-reg,qa-reg."
  type    = string
 }
variable "public_eks_name" {
  description = "The name is eks."
  type    = string  
 }
variable "public_nodename" {
  description = "The nodename like workernode."
  type    = string
 }
# variable "public_ssh_key_name" {
#   description = "The key_pair name of the region"
#   type    = string
#  }
 variable "admin_contact" {
    description = "A person or email list to be contacted if there are questions or issues with this service. "
    type = string
}
variable "service_id" {
    description = "The purpose of service_id tag is to easily associate everything related to a service."
    type = string
}
variable "service_data" {
    description = "The format for the service_data field is key=value and delimited by the plus ( + ) symbol"
    type = string
}
variable "public_desired_size" {
    description = "The format for the service_data field is key=value and delimited by the plus ( + ) symbol"
    type = string
}
variable "public_max_size" {
    description = "The format for the service_data field is key=value and delimited by the plus ( + ) symbol"
    type = string
}
variable "public_min_size" {
    description = "The format for the service_data field is key=value and delimited by the plus ( + ) symbol"
    type = string
}
variable "public_cidr_block" {
  description = "Value of the vpc cidr block"
  type = list(string)
}
# variable "public_keypair_security_group_name" {
#   description = "Name of public keypair security group"
# }