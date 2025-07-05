resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = "karpenter"
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  create_namespace = true

  values = ["${file("${path.module}/values.yaml")}"]
}
