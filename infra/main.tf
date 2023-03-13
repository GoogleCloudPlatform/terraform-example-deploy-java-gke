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

data "google_compute_zones" "available" {
  depends_on = [
    module.project_services
  ]
  project = var.project_id
  region  = var.region
}

locals {
  zones_base = {
    default = data.google_compute_zones.available.names
    user    = compact(var.zones)
  }
  zones = local.zones_base[length(compact(var.zones)) == 0 ? "default" : "user"]
  location = {
    region = var.region
    zones  = local.zones
  }
}

module "project_services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 14.1"
  disable_services_on_destroy = false
  project_id                  = var.project_id

  activate_apis = [
    "compute.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "storage.googleapis.com",
    "secretmanager.googleapis.com",
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "file.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "monitoring.googleapis.com"
  ]
}

resource "google_compute_network" "xwiki" {
  depends_on = [
    module.project_services
  ]

  project                 = var.project_id
  name                    = "xwiki"
  auto_create_subnetworks = true
}

resource "random_password" "sql" {
  length           = 20
  min_lower        = 4
  min_numeric      = 4
  min_upper        = 4
  override_special = "!#%*()-_=+[]{}:?"
}

module "database" {
  depends_on = [
    module.project_services
  ]
  source = "./modules/database"

  region                  = local.location["region"]
  private_network_id      = google_compute_network.xwiki.id
  availability_type       = "REGIONAL"
  xwiki_sql_user_password = random_password.sql.result
}

resource "google_filestore_instance" "xwiki" {
  depends_on = [
    module.project_services
  ]

  name     = "xwiki-filestore"
  tier     = "BASIC_HDD"
  location = local.location["zones"][0]
  networks {
    network = google_compute_network.xwiki.name
    modes   = ["MODE_IPV4"]
  }
  file_shares {
    capacity_gb = 1024
    name        = "xwiki_file_share"
  }
}

data "google_project" "project" {

}

resource "google_storage_bucket" "xwiki_jgroup" {
  depends_on = [
    module.project_services
  ]

  name          = "xwiki-jgroup-${data.google_project.project.number}"
  project       = var.project_id
  location      = local.location["region"]
  force_destroy = true
}

resource "google_service_account" "jgroup" {
  depends_on = [
    module.project_services
  ]
  account_id = "xwiki-jroup"
}

resource "google_project_iam_member" "jgroup_permission" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.jgroup.email}"
}

resource "google_storage_hmac_key" "jgroup" {
  service_account_email = google_service_account.jgroup.email
}

module "kubernetes_cluster" {
  depends_on = [
    module.project_services,
    module.database
  ]
  source = "./modules/kubernetes"

  cluster_name            = var.cluster_name
  region                  = local.location["region"]
  zones                   = local.location["zones"]
  xwiki_network_self_link = google_compute_network.xwiki.self_link
}

module "helm" {
  depends_on = [
    module.kubernetes_cluster,
  ]
  source = "./modules/helm"

  entries = [
    {
      name  = "project_id"
      value = var.project_id
    },
    {
      name  = "region"
      value = local.location["region"]
    },
    {
      name  = "image"
      value = var.image
    },
    {
      name  = "config_maps.db_host"
      value = module.database.db_ip
    },
    {
      name  = "config_maps.db_user"
      value = module.database.xwiki_user_name
    },
    {
      name  = "config_maps.nfs_ip_address"
      value = google_filestore_instance.xwiki.networks[0].ip_addresses[0]
    },
    {
      name  = "config_maps.jgroup_bucket_name"
      value = google_storage_bucket.xwiki_jgroup.name
    },
  ]
  secret_entries = [
    {
      name  = "secrets.access_key"
      value = google_storage_hmac_key.jgroup.access_id
    },
    {
      name  = "secrets.secret_key"
      value = google_storage_hmac_key.jgroup.secret
    },
    {
      name  = "secrets.db_password"
      value = random_password.sql.result
    },
  ]
}

resource "google_monitoring_dashboard" "xwiki" {
  dashboard_json = file("${path.module}/files/xwiki_gke_monitor_dashboard.json")
}
