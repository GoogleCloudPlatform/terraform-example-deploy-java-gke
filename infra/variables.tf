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

variable "project_id" {
  description = "GCP project ID."
  type        = string
  validation {
    condition     = var.project_id != ""
    error_message = "Error: project_id is required"
  }
}

variable "region" {
  description = "google cloud region where the resource will be created."
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "List of zones are deployment areas within a region."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
}

variable "image" {
  description = "Xwiki docker image"
  type        = string
  default     = "gcr.io/migrate-legacy-java-app-gke/hsa-xwiki:latest"
}

variable "cluster_name" {
  description = "The name of the cluster (required)"
  type        = string
  default     = "xwiki"
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the resources."
  type        = map(string)

  default = {
    app = "terraform-example-deploy-java-gke"
  }
}
