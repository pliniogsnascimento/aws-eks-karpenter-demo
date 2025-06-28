module "cluster" {
  source = "git::https://github.com/pliniogsnascimento/aws-eks-terraform.git//resources?ref=master"

  cluster_name = local.cluster_name

  providers = {
    aws.main = aws
  }
}

data "aws_caller_identity" "current" {}


