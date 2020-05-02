data "aws_vpc" "main" {
  tags = {
    Name = var.environment
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "Private"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Name = "Public"
  }
}

data "aws_ecs_cluster" "main" {
  cluster_name = var.environment
}

data "aws_caller_identity" "current" {
}

