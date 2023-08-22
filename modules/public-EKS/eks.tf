resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.public_eks_name}-role"
  tags = {
    Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}


resource "aws_eks_cluster" "public_aws_eks" {
  name     = var.public_eks_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.public_version_no

  tags = {
		Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
	}

  vpc_config {
    subnet_ids         = var.public_vpc_private_subnet_ids
    endpoint_private_access      =  "true"
    endpoint_public_access       =  "true"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}

resource "aws_iam_role" "eks_nodes_role" {
  name = "${var.public_eks_name}_${var.public_nodename}-role"
  tags = {
		Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
  }

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "policy" {
  name        = "${var.public_eks_name}_worker_node_policy"
  description = "A policy attached to workernode for the aws resources access"
  policy      = "${file("${path.module}/policyaware.json")}"
  # path = "/"
  # policy      = file("policyaware.json")
  
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_role.name
}

resource "aws_iam_role_policy_attachment" "aware-eks-workenode-policy" {
  role      = aws_iam_role.eks_nodes_role.name
  policy_arn = "${aws_iam_policy.policy.arn}"
}

#resource "aws_iam_role_policy_attachment" "aware_eks_workernode_policy" {
#  policy_arn = "arn:aws:iam::901204618237:policy/aware_eks_workernode_policy"
#  role       = aws_iam_role.eks_nodes.name
#}

resource "aws_eks_node_group" "node" {
  cluster_name    = aws_eks_cluster.public_aws_eks.name
  node_group_name = "${var.public_eks_name}_${var.public_nodename}"
  node_role_arn   = aws_iam_role.eks_nodes_role.arn
  subnet_ids      = var.public_vpc_private_subnet_ids
  instance_types = var.public_instance_types
  ami_type = var.public_ami_type

  scaling_config {
    desired_size = var.public_desired_size
    max_size     = var.public_max_size
    min_size     = var.public_min_size
  }
  remote_access {
    # ec2_ssh_key               = var.public_ssh_key_name
    source_security_group_ids = [aws_security_group.public_keypair_security_group.id]
  }
  tags = {
		key                 = "Name"
    value               = "eks-workers"
    propagate_at_launch = true
    Environment = var.environment
    admin_contact = var.admin_contact
    service_id  = var.service_id
    service_data  = var.service_data
	}

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_security_group.public_keypair_security_group,
  ]
}
resource "aws_security_group" "public_keypair_security_group" {
    name        = "dev_public_keypair_security_group"
    description = "Allow TLS inbound traffic"
    vpc_id      = var.public_vpc_id
  
    ingress {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = var.public_cidr_block
    }
  
    egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["10.0.0.0/16"]
    }
  
    tags = {
        Environment = var.environment
        admin_contact = var.admin_contact
        service_id  = var.service_id
        service_data  = var.service_data
    }
  }
