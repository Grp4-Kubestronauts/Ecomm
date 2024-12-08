data "aws_eks_cluster_auth" "secondary" {
  name = aws_eks_cluster.secondary.name
}

provider "kubernetes" {
  host                   = aws_eks_cluster.secondary.endpoint
  token                  = data.aws_eks_cluster_auth.secondary.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.secondary.certificate_authority[0].data)
}

resource "kubernetes_namespace" "dr" {
  metadata {
    name = "dr"
  }
}
