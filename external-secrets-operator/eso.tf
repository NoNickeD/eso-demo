# Create Kubernetes Namespace
resource "kubernetes_namespace" "external_secrets_ns" {
  metadata {
    name = "external-secrets"
  }
}

# Deploy External Secrets Operator via Helm
resource "helm_release" "external_secrets" {
  name             = "external-secrets"
  chart            = "external-secrets"
  namespace        = kubernetes_namespace.external_secrets_ns.metadata[0].name
  repository       = "https://charts.external-secrets.io"
  create_namespace = false

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_secrets_role.arn
  }

  depends_on = [kubernetes_namespace.external_secrets_ns]
}


resource "aws_iam_policy" "external_secrets_policy" {
  name   = "ExternalSecretsPolicy"
  policy = data.aws_iam_policy_document.external_secrets_policy.json
}

# Create IAM Role with Correct OIDC Provider
resource "aws_iam_role" "external_secrets_role" {
  name = "ExternalSecretsRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Federated" : data.aws_iam_openid_connect_provider.oidc_provider.arn
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringEquals" : {
          "${replace(data.aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub" : "system:serviceaccount:external-secrets:external-secrets"
        }
      }
    }]
  })
}

# Attach IAM Policy to the Role
resource "aws_iam_role_policy_attachment" "external_secrets_attachment" {
  role       = aws_iam_role.external_secrets_role.name
  policy_arn = aws_iam_policy.external_secrets_policy.arn
}
