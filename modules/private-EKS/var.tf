 variable "version_no" {
  description = "version of the eks cluster"
  type    = string
 }
variable "vpc_id" {
  description = "VPC ID of the env"
  type    = string
 }
variable "private_subnet_ids" {
  description = "Mention 2 Subnet ID's"
  type    = list
}
data "aws_vpc" "selected" {
  id = var.vpc_id
 }
variable "instance_types" {
  description = "Mention instance types"
  type    = list
}
variable "ami_type" {
  description = "Mention 2 Subnet ID's"
  type = string 
}
variable "environment" {
  description = "The environment like dev,qa,prod, dev-reg,qa-reg."
  type    = string
 }
variable "eks_name" {
  description = "The name is eks."
  type    = string  
 }
variable "nodename" {
  description = "The nodename like workernode."
  type    = string
 }
variable "ssh_key_name" {
  description = "The key_pair name of the region"
  type    = string
 }
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
variable "desired_size" {
    description = "The format for the service_data field is key=value and delimited by the plus ( + ) symbol"
    type = string
}
variable "max_size" {
    description = "The format for the service_data field is key=value and delimited by the plus ( + ) symbol"
    type = string
}
variable "min_size" {
    description = "The format for the service_data field is key=value and delimited by the plus ( + ) symbol"
    type = string
}
variable "private_cidr_block" {
  description = "Value of the main vpc cidr block"
  type = list(string)
}