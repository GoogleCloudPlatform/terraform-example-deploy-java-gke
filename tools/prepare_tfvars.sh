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

REGION=$1
ZONES=$2
IMAGE=$3
CLUSTER_NAME=$4

IFS=" "
read -ra ZONE_ARRAY <<< "$ZONES"
printf -v ZONES_VALUE '"%s",' "${ZONE_ARRAY[@]}"
ZONES_VALUE="[${ZONES_VALUE%,}]"

cat << EOF > ../infra/terraform.tfvars
region       = "$REGION"
zones        = $ZONES_VALUE
image        = "$IMAGE"
cluster_name = "$CLUSTER_NAME"
EOF
