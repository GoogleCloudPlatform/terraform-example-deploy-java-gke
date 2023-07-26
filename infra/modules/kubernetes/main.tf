# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

resource "google_container_cluster" "control_plane" {
  name            = var.cluster_name
  location        = var.region
  network         = var.xwiki_network_self_link
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
  }

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  # If you're using google_container_node_pool objects with no default
  # node pool, you'll need to set this to a value of at least 1, alongside setting
  # remove_default_node_pool to true
  node_config {
    disk_size_gb = 25
  }
  remove_default_node_pool = true
  initial_node_count       = 1
  resource_labels          = var.labels
}

resource "google_container_node_pool" "worker_pool" {
  name           = "xwiki-gke-default-pool"
  location       = var.region
  node_locations = var.zones
  cluster        = google_container_cluster.control_plane.name
  node_count     = 1

  node_config {
    machine_type = "n2-standard-4"
    disk_size_gb = 25
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
  autoscaling {
    location_policy = "BALANCED"
    min_node_count  = 0
    max_node_count  = 1
  }
}
