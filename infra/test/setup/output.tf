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

output "project_id" {
  value = module.project_factory.project_id
}

output "db_ip" {
  description = "The IPv4 address assigned for the master instance"
  value       = module.database.db_ip
}

output "xwiki_url" {
  description = "The public URL of the XWiki application"
  value       = "http://${google_compute_address.xwiki.address}"
}
