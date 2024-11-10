resource "helm_release" "metrics_server" {
  for_each   = var.enable_metrics_server ? toset(["k8s-metrics-server"]) : toset([])
  chart      = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"

  name      = each.key
  namespace = "kube-system"

  depends_on = [module.eks]
}
