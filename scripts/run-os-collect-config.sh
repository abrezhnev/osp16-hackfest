#!/bin/bash
export ControllerDeployedServer_hosts="192.168.10.10 192.168.10.11 192.168.10.12"
export ComputeDeployedServer_hosts="192.168.10.13 192.168.10.14"
export OVERCLOUD_ROLES="ControllerDeployedServer ComputeDeployedServer"

source ~/stackrc
#export STACK_NAME="overcloud"

/usr/share/openstack-tripleo-heat-templates/deployed-server/scripts/get-occ-config.sh
