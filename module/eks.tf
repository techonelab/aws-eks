###EKS
##
#IAM role to allow assume role for rntespective users or service accou
resource "aws_iam_role" "cluster" {
  name = "${var.project}-cluster-role"

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
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}
#eks cluster main
resource "aws_eks_cluster" "demo-aks-eks" {
  name     = "${var.project}-cluster"
  role_arn = aws_iam_role.cluster.arn
  version  = "1.28"

  vpc_config {
    # security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    subnet_ids              = flatten([aws_subnet.public-sub[*].id, aws_subnet.private-sub[*].id])
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs     = ["0.0.0.0/0"]
  }
  tags = merge(
    var.tags
  )
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}
#eks cluster security group
resource "aws_security_group" "eks-cluster-sg" {
  name        = "${var.project}-cluster-sg"
  vpc_id      = aws_vpc.demo-aks-eks.id
  tags = {
    Name = "${var.prject}-cluster-sg"
  }
}
#policy for eks cluster sg allow incoming traffic from port 443
resource "aws_security_group_rule" "eks-sg-443inbound-rule" {
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster-sg.id
  source_security_group_id = aws_security_group.eks-nodes-sg.id
  to_port                  = 443
  type                     = "ingress"
}
#policy for eks cluster sg allow outgoing traffic within k8s ports
resource "aws_security_group_rule" "eks-sg-k8soutbound-rule" {
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-cluster-sg.id
  source_security_group_id = aws_security_group.eks-nodes-sg.id
  to_port                  = 65535
  type                     = "egress"
}
#eks cluster nodes
#eks node iam role
resource "aws_iam_role" "node" {
  name = "${var.project}-Worker-Role"

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

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}
#eks cluster nodes
resource "aws_eks_node_group" "demo-aks-eks-node-group" {
  cluster_name    = aws_eks_cluster.demo-aks-eks.name
  node_group_name = var.project
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.private[*].id
  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }
  ami_type       = "AL2_x86_64" # AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64, CUSTOM
  capacity_type  = "ON_DEMAND"  # ON_DEMAND, SPOT
  disk_size      = 20
  instance_types = ["t2.medium"]
  tags = merge(
    var.tags
  )
  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
}
#eks node security group
resource "aws_security_group" "eks-nodes-sg" {
  name        = "${var.project}-node-sg"
  vpc_id      = aws_vpc.demo-aws-eks.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                                           = "${var.project}-node-sg"
    "kubernetes.io/cluster/${var.project}-cluster" = "owned"
  }
}
#policy for eks node sg allow incoming traffic from all port from within nodes
resource "aws_security_group_rule" "eks-node-sg-inbound-rule" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks-nodes-sg.id
  source_security_group_id = aws_security_group.eks-nodes-sg.id
  to_port                  = 65535
  type                     = "ingress"
}
#policy for eks node sg allow tincoming raffic within k8s port cluster wide
resource "aws_security_group_rule" "eks-node-sg-k8sinbound-rule" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks-nodes-sg.id
  source_security_group_id = aws_security_group.eks-cluster-sg.id
  to_port                  = 65535
  type                     = "ingress"
}