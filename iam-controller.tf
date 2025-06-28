resource "aws_iam_policy" "karpenter_controller_policy" {
  policy = templatefile("${path.module}/policy.json", { 
    cluster_name = local.cluster_name, 
    account_id = data.aws_caller_identity.current.account_id,
    node_role_arn = resource.aws_iam_role.karpenter_node_role.arn,
    interruption_queue_arn = resource.aws_sqs_queue.karpenter_interruption_queue.arn
  })
}
