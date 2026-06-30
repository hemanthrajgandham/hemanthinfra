resource "aws_eks_cluster" "cluster" {
  name = "${var.prefix}-eks-cluster"

  access_config {
    authentication_mode = "API"
    bootstrap_cluster_creator_admin_permissions =  true
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.34"
compute_config {
    enabled = false
  }

  kubernetes_network_config {
    elastic_load_balancing {
      enabled = false
    }
  }

  storage_config {
    block_storage {
      enabled = false
    }
  }


  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids = var.eks_subnet_ids
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
   
  ]
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-cluster"
    }
  )
}

resource "aws_iam_role" "node" {
  name = "${var.prefix}-eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = ["sts:AssumeRole"]
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-node-group-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}
resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role" "cluster" {
  name = "${var.prefix}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-cluster-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "${var.prefix}-eks-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.eks_subnet_ids
  instance_types   = var.node_instance_type

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [ 
    aws_eks_cluster.cluster,
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-eks-node-group"
    }
  )
}

data "aws_eks_cluster" "example" {
  name = "${var.prefix}-eks-cluster-role"
}

