resource "null_resource" "kubeconfig" {
  depends_on = [aws_eks_node_group.main]

  triggers = {
    always = timestamp()
  }

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${var.env}"
  }
}


resource "null_resource" "metrics-server" {
  depends_on = [null_resource.kubeconfig]

  provisioner "local-exec" {
    command = "kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
  }
}


resource "helm_release" "kube-prometheus-stack" {
  depends_on = [null_resource.kubeconfig, helm_release.ingress, helm_release.cert-manager]
  name       = "kube-prom-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [templatefile("${path.module}/helm-config/prom-stack-template.yml", {
    SMTP_user_name = data.vault_generic_secret.smtp.data["username"]
    SMTP_password  = data.vault_generic_secret.smtp.data["password"]
  })]
}


resource "helm_release" "ingress" {
  depends_on = [null_resource.kubeconfig]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"

  values = [
    file("${path.module}/helm-config/ingress.yml")
  ]

}

resource "helm_release" "cert-manager" {
  depends_on       = [null_resource.kubeconfig]
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }
}

resource "null_resource" "cert-manager-cluster-issuer" {
  depends_on = [null_resource.kubeconfig, helm_release.cert-manager]

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/helm-config/cluster-issuer.yml"
  }
}

resource "helm_release" "external-dns" {
  depends_on = [null_resource.kubeconfig]
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
}


resource "helm_release" "argocd" {
  depends_on = [null_resource.kubeconfig, helm_release.external-dns, helm_release.ingress, helm_release.cert-manager]

  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  wait             = false

  set {
    name  = "global.domain"
    value = "argocd-${var.env}.rdevopsb83.online"
  }

  values = [
    file("${path.module}/helm-config/argocd.yml")
  ]
}

## Filebeat Helm Chart
resource "helm_release" "filebeat" {

  depends_on = [null_resource.kubeconfig]
  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  namespace  = "kube-system"
  wait       = "false"

  values = [
    file("${path.module}/helm-config/filebeat.yml")
  ]
}


#$ helm repo add autoscaler https://kubernetes.github.io/autoscaler
#helm install my-release autoscaler/cluster-autoscaler \
#    --set 'autoDiscovery.clusterName'=<CLUSTER NAME>

# Cluster Autoscaler

resource "helm_release" "cluster-autoscaler" {

  depends_on = [null_resource.kubeconfig]
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  wait       = "false"

  set {
    name  = "autoDiscovery.clusterName"
    value = var.env
  }
  set {
    name  = "awsRegion"
    value = "us-east-1"
  }
}

# External Secrets

resource "helm_release" "external-secrets" {

  depends_on = [null_resource.kubeconfig]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "kube-system"
  wait       = "false"

  set {
    name  = "installCRDs"
    value = true
  }
}

resource "null_resource" "external-secret-store" {
  depends_on = [helm_release.external-secrets]
  provisioner "local-exec" {
    command = <<EOF
kubectl create ns app
kubectl apply -f - <<EOK
apiVersion: v1
kind: Secret
metadata:
  name: vault-token
  namespace: app
data:
  token: aHZzLjVnM1RDTzdjbnZBVzQxRGZVV1NLanRHWA==
---
apiVersion: external-secrets.io/v1
kind: ClusterSecretStore
metadata:
  name: vault-backend
spec:
  provider:
    vault:
      server: "http://vault-internal.rdevopsb83.online:8200"
      path: "roboshop-${var.env}"
      version: "v2"
      auth:
        tokenSecretRef:
          name: "vault-token"
          key: "token"
EOK
EOF
  }
}

# Config Reloader

resource "helm_release" "wave-config-reloader" {

  depends_on = [null_resource.kubeconfig]
  name       = "wave"
  repository = "https://wave-k8s.github.io/wave/"
  chart      = "wave"
  namespace  = "kube-system"
  wait       = "false"

  set {
    name  = "webhooks.enabled"
    value = true
  }
}

resource "helm_release" "istio-base" {
  depends_on = [
    null_resource.kubeconfig
  ]

  name             = "istio-base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "base"
  namespace        = "istio-system"
  create_namespace = true
}

resource "helm_release" "istiod" {
  depends_on = [
    null_resource.kubeconfig,
    helm_release.istio-base
  ]

  name             = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  chart            = "istiod"
  namespace        = "istio-system"
  create_namespace = true
}

# resource "helm_release" "kiali" {
#   depends_on = [
#     null_resource.kubeconfig,
#     helm_release.istiod
#   ]
#
#   name             = "kiali-server"
#   repository       = "https://kiali.org/helm-charts"
#   chart            = "kiali-server"
#   namespace        = "istio-system"
#   create_namespace = true
#   set {
#     name  = "server.web_fqdn"
#     value = "kiali-${var.env}.rdevopsb83.online"
#   }
#   set {
#     name  = "deployment.ingress.enabled"
#     value = true
#   }
# }

resource "null_resource" "kiali" {
    depends_on = [
      null_resource.kubeconfig,
      helm_release.istiod
    ]
  provisioner "local-exec" {
    command = <<EOF
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.26/samples/addons/kiali.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.26/samples/addons/prometheus.yaml
kubectl apply -f - <<EOK
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: HTTP
    nginx.ingress.kubernetes.io/secure-backends: "false"
  name: kiali
  namespace: istio-system
spec:
  ingressClassName: nginx
  rules:
  - host: kiali-dev.rdevopsb83.online
    http:
      paths:
      - backend:
          service:
            name: kiali
            port:
              number: 20001
        path: /kiali
        pathType: Prefix
EOK
EOF
  }
}

