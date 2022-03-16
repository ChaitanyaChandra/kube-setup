resource "aws_eks_cluster" "primary" {
  name     = "${local.tags.Service}-${local.Environment}-${var.cluster_name}-${local.region}-${local.env_tag.appenv}"
  role_arn = aws_iam_role.control_plane.arn
  version  = var.k8s_version

  vpc_config {
    security_group_ids = [aws_security_group.worker.id]
    subnet_ids         = aws_subnet.worker[*].id
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster,
    aws_iam_role_policy_attachment.service,
  ]
  tags = local.tags
}

resource "aws_iam_role" "control_plane" {
  name               = "${local.tags.Service}-${local.Environment}-eks-role"
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
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "cluster" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.control_plane.name
}

resource "aws_iam_role_policy_attachment" "service" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.control_plane.name
}

resource "aws_vpc" "worker" {
  cidr_block = "10.0.0.0/16"
  tags       = local.tags
}

resource "aws_security_group" "worker" {
  name        = "${local.tags.Service}-${local.Environment}-eks-worker-sg"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.worker.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.tags
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "worker" {
  count                   = 3
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.0.${count.index}.0/24"
  vpc_id                  = aws_vpc.worker.id
  map_public_ip_on_launch = true
  tags                    = local.tags
}