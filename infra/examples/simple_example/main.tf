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

module "simple" {
  source = "../../"

  project_id   = var.project_id
  region       = "us-central1"
  zones        = ["us-central1-a", "us-central1-b"]
  image        = "gcr.io/devops-356804/xwiki-14.10.2-mysql8.0@sha256:af01b1845a8f06bfa60ef77277809616373cb41b111ab5abd5bf26f8399fc861"
  cluster_name = "test"
}
