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

variable "cluster_name" {
  description = "The name of the cluster (required)"
  type        = string
}

variable "region" {
  description = "The region to host the k8s cluster"
  type        = string
}

variable "zones" {
  description = "The zones to host the k8s cluster"
  type        = list(string)
}

variable "xwiki_network_self_link" {
  description = "The VPC network self_link to host the k8s cluster"
  type        = string
}

variable "labels" {
  description = "A map of key/value label pairs to assign to the resources."
  type        = map(string)
}
