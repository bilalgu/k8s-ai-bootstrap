output "gke_cluster_name" {
  value = google_container_cluster.primary.name
}

output "gke_cluster_endpoint" {
    value = google_container_cluster.primary.endpoint
}

output "gke_cluster_master_version" {
    value = google_container_cluster.primary.master_version
}