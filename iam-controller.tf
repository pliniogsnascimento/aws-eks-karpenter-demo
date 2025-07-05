resource "aws_iam_policy" "karpenter_controller_policy" {
  policy = templatefile("${path.module}/policy.json", {
    cluster_name           = local.cluster_name,
    account_id             = data.aws_caller_identity.current.account_id,
    node_role_arn          = resource.aws_iam_role.karpenter_node_role.arn,
    interruption_queue_arn = resource.aws_sqs_queue.karpenter_interruption_queue.arn
  })
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "karpenter_controller_role" {
  name               = "Karpenter-${local.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = {
    name = "karpenter-demo"
  }
}

resource "aws_iam_role_policy_attachment" "karpenter_controller_role" {
  policy_arn = aws_iam_policy.karpenter_controller_policy.arn
  role       = aws_iam_role.karpenter_controller_role.name
}

resource "aws_eks_pod_identity_association" "karpenter" {
  cluster_name    = module.cluster.cluster_name
  namespace       = "karpenter"
  service_account = "karpenter"
  role_arn        = aws_iam_role.karpenter_controller_role.arn
}
