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


LB_IP="$(gcloud compute forwarding-rules list --format="value(IP_ADDRESS)")"

wget -N https://storage.googleapis.com/jmeter-load-test-2023013117/apache-jmeter-5.5.zip
#wget -N https://storage.googleapis.com/jmeter-load-test-2023013117/run_load_test_v1.sh
#sudo apt-get update -y
#sudo apt-get install openjdk-11-jdk -y
#sudo apt-get install unzip
test -d apache-jmeter-5.5 || unzip apache-jmeter-5.5.zip

# Trun off sticky session
CLUSTER_NAME="$(gcloud container clusters list | cut -d ":" -f2 | head -1)"
echo "The current used cluster name is ${CLUSTER_NAME}"

REGION=$(gcloud container clusters list --format="value(LOCATION)")
gcloud container clusters get-credentials ${CLUSTER_NAME} --zone $REGION

SERVICE_NAME=$(kubectl get service | grep "LoadBalancer" | cut -d " " -f1)
echo "The Current used expose service name is $SERVICE_NAME"
kubectl patch services ${SERVICE_NAME} -p '{"spec": {"sessionAffinity": "None"}}'

TYPE=GKE

JMETER_DIR="${PWD}/apache-jmeter-5.5"
test -d ${JMETER_DIR}/plan || mkdir ${JMETER_DIR}/plan
DATE="$(date +%Y-%m%d-%H%M)"

case $TYPE in
       "GCE")
  	    wget https://storage.googleapis.com/jmeter-load-test-2023013117/xwiki_load_test.jmx -O ./xwiki_load_test.jmx
            cp xwiki_load_test.jmx ${JMETER_DIR}/plan/
            JMETER_CONFIG="${JMETER_DIR}/plan/xwiki_load_test.jmx"
            ;;

       "GKE")
  	    wget https://storage.googleapis.com/jmeter-load-test-2023013117/xwiki_load_test_gke_30.jmx -O ./xwiki_load_test_gke_30.jmx
            cp xwiki_load_test_gke_30.jmx ${JMETER_DIR}/plan/
            JMETER_CONFIG="${JMETER_DIR}/plan/xwiki_load_test_gke_30.jmx"
            ;;
esac


sed -i "s/LOAD_BALANCER_IP/${LB_IP}/g" ${JMETER_CONFIG}
/bin/sh ${JMETER_DIR}/bin/jmeter -n -t ${JMETER_CONFIG} -l output_gcp_${DATE}.jtl -j jmeter_${DATE}.log

#sh -x run_load_test_v1.sh "${LB_IP}" "GKE" &
