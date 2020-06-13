#!/usr/bin/env bash

CLASSROOM_SERVER=10.149.23.10
IMAGES_DIR=/var/lib/libvirt/images
OFFICIAL_IMAGE=rhel7-guest-official.qcow2
PASSWORD_FOR_VMS='r3dh4t1!'
VIRT_DOMAIN='example.com'

for i in {0..4}
do
  VM=node-$i

  virt-resize --expand /dev/sda1 ${IMAGES_DIR}/${OFFICIAL_IMAGE} ${IMAGES_DIR}/${VM}.qcow2

  virt-customize -a ${IMAGES_DIR}/${VM}.qcow2 \
    --hostname ${VM}.example.com \
    --root-password password:${PASSWORD_FOR_VMS} \
    --uninstall cloud-init \
    --selinux-relabel
done

