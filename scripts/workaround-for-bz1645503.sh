#!/bin/bash
export OVERCLOUD_HOSTS="192.168.10.13 192.168.10.14"
bash /usr/share/openstack-tripleo-heat-templates/deployed-server/scripts/enable-ssh-admin.sh
