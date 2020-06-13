#!/usr/bin/env bash

CLASSROOM_SERVER=10.149.23.10
IMAGES_DIR=/var/lib/libvirt/images
#OFFICIAL_IMAGE=rhel-8.qcow2
OFFICIAL_IMAGE=rhel7-guest-official.qcow2
PASSWORD_FOR_VMS='r3dh4t1!'
VIRT_DOMAIN='example.com'
export LIBGUESTFS_PATH=/var/lib/libvirt/images/appliance/

# Create virtual machines

# Define config files for network interfaces on the undercloud node
cat > /tmp/ifcfg-eth0 << EOF
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
UUID=c6048dd0-bd97-4881-b13e-3e261588f80c
DEVICE=eth0
ONBOOT=no
EOF

cat > /tmp/ifcfg-eth1 << EOF

/bin/basnOXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth1
UUID=cbc9e0bf-89f0-4fcc-b002-57ff6e37d524
DEVICE=eth1
ONBOOT=yes
IPADDR=10.1.0.2
PREFIX=24
GATEWAY=10.1.0.1
DNS1=${CLASSROOM_SERVER}
EOF

# Define the /etc/hosts file
cat > /tmp/hosts <<EOF
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

${CLASSROOM_SERVER}  classroom.example.com classroom
EOF

qemu-img create -f qcow2 ${IMAGES_DIR}/undercloud.qcow2 100G
virt-resize --expand /dev/sda1 ${IMAGES_DIR}/${OFFICIAL_IMAGE} ${IMAGES_DIR}/undercloud.qcow2
virt-customize -a ${IMAGES_DIR}/undercloud.qcow2 \
  --hostname undercloud.example.com \
  --root-password password:${PASSWORD_FOR_VMS} \
  --uninstall cloud-init \
  --selinux-relabel

virt-install --ram 24576 --vcpus 4 --machine q35 --os-variant rhel8.0 \
  --cpu host,+vmx \
  --disk path=${IMAGES_DIR}/undercloud.qcow2,device=disk,bus=virtio,format=qcow2 \
  --import --noautoconsole --vnc \
  --network network:ctlplane,mac=52:54:00:01:10:02 \
  --network network:external \
  --name undercloud \
  --dry-run --print-xml > /tmp/undercloud.xml

rm /tmp/hosts
rm /tmp/ifcfg-eth0
rm /tmp/ifcfg-eth1

virsh define --file /tmp/undercloud.xml
rm /tmp/undercloud.xml
