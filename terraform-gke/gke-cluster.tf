resource "google_container_cluster" "gke-cluster" {
  name               = "wordpress-gke-cluster"
  network            = "default"
  location           = "us-west2-c"
  initial_node_count = 3
}
