#!/bin/bash
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

PROJECT_ID=$1

bucketName=tf-backend-xwiki-gke-$(gcloud projects list --filter PROJECT_ID="${PROJECT_ID}" --format="value(projectNumber)")

status=$(gcloud storage buckets describe gs://"${bucketName}" 2>/dev/null)
if [ -z "${status}" ]; then
        echo "bucket not exist"
else
        echo "bucket exists, remove all file and delete bucket"
        gcloud storage rm -r gs://"${bucketName}"
fi
