#!/usr/bin/env bash

CLASSROOM_SERVER=10.149.23.10
IMAGES_DIR=/var/lib/libvirt/images
#OFFICIAL_IMAGE=rhel-8.qcow2
OFFICIAL_IMAGE=rhel7-guest-official.qcow2
PASSWORD_FOR_VMS='r3dh4t1!'
VIRT_DOMAIN='example.com'
export LIBGUESTFS_PATH=/var/lib/libvirt/images/appliance/

# Create virtual machines

qemu-img create -f qcow2 ${IMAGES_DIR}/bastion.qcow2 20G
virt-resize --expand /dev/sda1 ${IMAGES_DIR}/${OFFICIAL_IMAGE} ${IMAGES_DIR}/bastion.qcow2
virt-customize -a ${IMAGES_DIR}/bastion.qcow2 \
  --hostname bastion.example.com \
  --root-password password:${PASSWORD_FOR_VMS} \
  --uninstall cloud-init \
  --selinux-relabel

virt-install --ram 2048 --vcpus 2 --machine q35 --os-variant rhel8.0 \
  --cpu host,+vmx \
  --disk path=${IMAGES_DIR}/bastion.qcow2,device=disk,bus=virtio,format=qcow2 \
  --import --noautoconsole --vnc \
  --network network:ctlplane,mac=52:54:00:01:10:09 \
  --network network:external \
  --name bastion \
  --dry-run --print-xml > /tmp/bastion.xml


virsh define --file /tmp/bastion.xml
