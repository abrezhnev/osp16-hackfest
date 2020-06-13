#!/usr/bin/env bash

CLASSROOM_SERVER=10.149.23.10
IMAGES_DIR=/var/lib/libvirt/images
OFFICIAL_IMAGE=rhel7-guest-official.qcow2
PASSWORD_FOR_VMS='r3dh4t1!'
VIRT_DOMAIN='example.com'

# Create virtual machines

for i in {0..4}
do
  VM=node-$i
  OCTET6=$(( 20+$i ))

  qemu-img create -f qcow2 -o preallocation=metadata ${IMAGES_DIR}/${VM}.qcow2 60G

  virt-install --ram 16384 --vcpus 4 --machine q35 --os-variant rhel8.0 \
    --cpu host,+vmx \
    --disk path=${IMAGES_DIR}/${VM}.qcow2,device=disk,bus=virtio,format=qcow2 \
    --import --noautoconsole --vnc \
    --network network:ctlplane,mac=52:54:00:01:10:${OCTET6} \
    --network network:storage \
    --network network:storage_mgmt \
    --network network:internal_api \
    --network network:tenant \
    --network network:external \
    --name ${VM} \
    --dry-run --print-xml > /tmp/${VM}.xml

  virsh define --file /tmp/${VM}.xml
done
