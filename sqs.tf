resource "aws_sqs_queue" "karpenter_interruption_queue" {
  name                      = local.cluster_name
  message_retention_seconds = 300
  sqs_managed_sse_enabled   = true
}