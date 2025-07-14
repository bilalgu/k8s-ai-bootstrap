provider "google" {
  project = "k8s-ai-bootstrap"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

resource "google_container_cluster" "primary" {
  name = "k8s-ai-bootstrap"
  location = "europe-west1-b"

  initial_node_count = 1

  node_pool {
    name = "default-pool"
    node_count = 1

    autoscaling {
      min_node_count = 1
      max_node_count = 3
    }
  }
  
  node_config {
    machine_type = "e2-medium"
  }

  deletion_protection = false
}