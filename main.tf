module "cluster" {
  source = "git::https://github.com/pliniogsnascimento/aws-eks-terraform.git//resources?ref=master"

  cluster_name = local.cluster_name

  taints = [
    {
      key = "CriticalAddonsOnly"
      effect = "NO_SCHEDULE"
      value = "true"
    }
  ]

  min_size = 1
  max_size = 3
  desired_size = 2

  providers = {
    aws.main = aws
  }
}

data "aws_caller_identity" "current" {}


