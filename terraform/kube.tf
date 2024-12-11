resource "kubernetes_namespace" "kube-namespace" {
  metadata {
    name = "kube-by-tf"
  }
}

locals {
  elk_namespace = kubernetes_namespace.kube-namespace.metadata[0].name
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = local.elk_namespace
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          name  = "nginx"
          image = "nginx:latest"
          port {
            name           = "http"
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx_service" {
  metadata {
    name      = "nginx-service"
    namespace = local.elk_namespace
  }

  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata[0].labels.app
    }

    type = "NodePort"

    port {
      name        = "http"
      port        = 80
      target_port = 80
      node_port   = 30080
    }
  }
}

### elk_stack ###
# Logstash
resource "helm_release" "logstash" {
  depends_on = [kubernetes_namespace.kube-namespace]
  name       = "logstash"
  chart      = "${path.module}/../ELK/logstash"
  namespace  = local.elk_namespace
  values     = [file("${path.module}/../ELK/logstash/values.yaml")]
}

# Filebeat
resource "helm_release" "filebeat" {
  depends_on = [
    kubernetes_namespace.kube-namespace,
    helm_release.logstash
    ]
  name       = "filebeat"
  chart      = "${path.module}/../ELK/filebeat"
  namespace  = local.elk_namespace
  values     = [file("${path.module}/../ELK/filebeat/values.yaml")]
}

# Elasticsearch
resource "helm_release" "elasticsearch" {
  depends_on = [
    kubernetes_namespace.kube-namespace,
    helm_release.filebeat
    ]
  name       = "elasticsearch"
  chart      = "${path.module}/../ELK/elasticsearch"
  namespace  = local.elk_namespace
  values     = [file("${path.module}/../ELK/elasticsearch/values.yaml")]
}


# Kibana
resource "helm_release" "kibana" {
  depends_on = [
    kubernetes_namespace.kube-namespace,
    helm_release.elasticsearch
    ]
  name       = "kibana"
  chart      = "${path.module}/../ELK/kibana"
  namespace  = local.elk_namespace
  values     = [file("${path.module}/../ELK/kibana/values.yaml")]
}
