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

locals {
  roles = [
    "roles/cloudbuild.builds.builder",
    "roles/cloudbuild.serviceAgent",
    "roles/cloudsql.admin",
    "roles/compute.networkAdmin",
    "roles/logging.admin",
    "roles/monitoring.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/secretmanager.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.hmacKeyAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/container.admin",
    "roles/container.serviceAgent",
    "roles/logging.admin"
  ]
}

resource "google_service_account" "test" {
  project    = module.project_factory.project_id
  account_id = "ci-hsa"
}

resource "google_project_iam_member" "test" {
  for_each = toset(local.roles)

  project = module.project_factory.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.test.email}"
}

resource "google_service_account_key" "test" {
  service_account_id = google_service_account.test.id
}
