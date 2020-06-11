#!/bin/bash
set -ex

DEPLOY_STACK=overcloud
DEPLOY_TIMEOUT_ARG=90
THT=/usr/share/openstack-tripleo-heat-templates
CFG=~/templates

source /home/stack/stackrc

openstack overcloud deploy --templates $THT --stack $DEPLOY_STACK --timeout $DEPLOY_TIMEOUT_ARG \
-r $CFG/deployed-server-roles-data.yaml \
-n $CFG/network_data.yaml \
-e $THT/environments/deployed-server-environment.yaml \
-e $THT/environments/deployed-server-bootstrap-environment-rhel.yaml \
-e $THT/environments/deployed-server-pacemaker-environment.yaml \
-e $THT/environments/disable-telemetry.yaml \
-e $THT/environments/network-isolation.yaml \
-e $THT/environments/network-environment.yaml \
-e $CFG/environments/network-environment.yaml \
-e $CFG/environments/net-multiple-nics.yaml \
-e $CFG/environments/ips-from-pool-all.yaml \
-e $CFG/environments/fixed-ip-vips.yaml \
-e $CFG/ctlplane-assignments.yaml \
-e $CFG/container-image-prepare.yaml \
-e $CFG/parameters.yaml \
--disable-validations
