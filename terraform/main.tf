provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_pod" "db" {
  metadata {
    name = "db"
    labels = {
      app = "db"
    }
  }
  spec {
    container {
      image = "postgres:latest"
      name  = "db"
      
      env {
        name = "POSTGRES_DB"
        value = "postgres"
      }
      env {
        name = "POSTGRES_USER"
        value = "postgres"
      }
      env {
        name = "POSTGRES_PASSWORD"
        value = "postgres"
      }
      port {
        container_port = 5432
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name = "backend-service"
  }
  spec {
    selector = {
      app = "backend"
    }
    port {
      port        = 8000
      target_port = 8000
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_pod" "backend" {
  metadata {
    name = "backend"
    labels = {
      app = "backend"
    }
  }
  spec {
    container {
      image = "charmingsteve/tempbackend:latest"
      name  = "backend"
      
      env {
        name = "DB_DATABASE"
        value = "postgres"
      }
      env {
        name = "DB_HOST"
        value = "db"
      }
      env {
        name = "DB_USER"
        value = "postgres"
      }
      env {
        name = "DB_PASSWORD"
        value = "postgres"
      }
      port {
        container_port = 8000
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "frontend-service"
  }
  spec {
    selector = {
      app = "frontend"
    }
    port {
      port        = 3000
      target_port = 3000
    }
    type = "LoadBalancer"
  }
}

resource "kubernetes_pod" "frontend" {
  metadata {
    name = "frontend"
    labels = {
      app = "frontend"
    }
  }
  spec {
    container {
      image = "charmingsteve/tempfrontend:latest"
      name  = "frontend"
      port {
        container_port = 3000
      }
    }
  }
}

