data "aws_vpc" "rds_vpc" {
  id    = var.vpc_id
}

resource "aws_security_group" "dev_private_postgredb" {
  name = "${var.db_identifier}-new-firewall"

  description = "Private psql RDS postgres servers (terraform-managed)"
  vpc_id = var.vpc_id

  # Only postgres in
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/8","100.0.0.0/8",data.aws_vpc.rds_vpc.cidr_block]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/8","100.0.0.0/8",data.aws_vpc.rds_vpc.cidr_block]
  }
  tags = {
    Name =  "psql-rds-${var.environment}-sg"
    Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
  }
}

resource "aws_security_group" "dev_private_mysqldb" {
  name = "mysql-rds-${var.db_identifier}-firewall"

  description = "Private mysql RDS postgres servers (terraform-managed)"
  vpc_id = var.vpc_id

  # Only mysqlin
  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/8","100.0.0.0/8",data.aws_vpc.rds_vpc.cidr_block]
  }

  # Allow all outbound traffic.
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/8","100.0.0.0/8",data.aws_vpc.rds_vpc.cidr_block]
  }
  tags = {
    Name =  "mysql-rds-${var.environment}-sg"
    Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
  }
}

#-------------------------------
# RDS
#-------------------------------
resource "aws_db_instance" "private_rds_instance" {
  allocated_storage    = 100
  db_subnet_group_name = aws_db_subnet_group.private_db_subnet_group.name
  engine               = var.db_engine
  engine_version       = var.db_engine_version
  identifier           = var.db_identifier
  instance_class       = var.db_instance_class
  password             = var.db_password
  publicly_accessible  = var.publicly_accessible
  skip_final_snapshot  = true
  storage_encrypted    = true
  auto_minor_version_upgrade  = false
  vpc_security_group_ids = [aws_security_group.dev_private_postgredb.id]
  username             = var.db_username
  tags = {
    Name =  var.db_identifier
    Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
  }
}
#-------------------------------
# DB Subnet group
#-------------------------------
resource "aws_db_subnet_group" "private_db_subnet_group" {
  name       = "${var.db_identifier}-new-private-sbg"
  subnet_ids = var.rds_private_subnet_ids

  tags = {
    Name =  "${var.db_identifier}-private-sbg"
    Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
  }
}
