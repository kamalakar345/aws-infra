variable "environment" {
    description = "Environment"
    type = string
}
variable "region" {
    description = "Environment"
    type = string
}
variable "vpc_id" {
    description = "includes VPC ID"
    type = string
}
variable "db_instance_class" {
    description = "DB Instance type"
    type = string
}  
variable "db_password" {
    description = "DB password"
    type = string
}
variable "db_engine_version" {
    description = "DB engine version"
    type = string
}
variable "db_username" {
    description = "DB Username"
    type = string
}
variable "db_engine" {
    description = "DB kind of engine"
    type = string
}
variable "db_identifier" {
    description = "DB identifier"
    type = string
}
variable "db_subnet_group_name" {
  description = "Apparently the group name, according to the RDS launch wizard."
}
variable "rds_private_subnet_ids" {
  description = "Pass the private subnet id"
  type = list(string)
}
variable "publicly_accessible" {
  description = "Pass true or false for private or public"
  type = bool
  default = false
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