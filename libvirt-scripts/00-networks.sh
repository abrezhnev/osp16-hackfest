#!/usr/bin/env bash

### Create the networks required for environment.

cat > /tmp/ctlplane.xml <<EOF
<network>
  <name>ctlplane</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <ip address="192.168.10.1" netmask="255.255.255.0">
    <dhcp>
      <host mac='52:54:00:01:10:02' name='undercloud' ip='192.168.10.2'/>
      <host mac='52:54:00:01:10:09' name='bastion' ip='192.168.10.9'/>
      <host mac='52:54:00:01:10:20' name='node-0' ip='192.168.10.10'/>
      <host mac='52:54:00:01:10:21' name='node-1' ip='192.168.10.11'/>
      <host mac='52:54:00:01:10:22' name='node-2' ip='192.168.10.12'/>
      <host mac='52:54:00:01:10:23' name='node-3' ip='192.168.10.13'/>
      <host mac='52:54:00:01:10:24' name='node-4' ip='192.168.10.14'/>
      <host mac='52:54:00:01:10:25' name='node-5' ip='192.168.10.15'/>
      <host mac='52:54:00:01:10:26' name='node-6' ip='192.168.10.16'/>
    </dhcp>
  </ip>
</network>
EOF

virsh net-define /tmp/ctlplane.xml
virsh net-autostart ctlplane
virsh net-start ctlplane

cat > /tmp/storage.xml <<EOF
<network>
  <name>storage</name>
  <ip address="172.16.0.1" netmask="255.255.255.0"/>
</network>
EOF

cat > /tmp/storage_mgmt.xml <<EOF
<network>
  <name>storage_mgmt</name>
  <ip address="172.17.0.1" netmask="255.255.255.0"/>
</network>
EOF

cat > /tmp/internal_api.xml <<EOF
<network>
  <name>internal_api</name>
  <ip address="172.18.0.1" netmask="255.255.255.0"/>
</network>
EOF

cat > /tmp/tenant.xml <<EOF
<network>
  <name>tenant</name>
  <ip address="172.19.0.1" netmask="255.255.255.0"/>
</network>
EOF

cat > /tmp/external.xml <<EOF
<network>
  <name>external</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <ip address="10.1.0.1" netmask="255.255.255.0"/>
</network>
EOF

for NETWORK in storage storage_mgmt internal_api tenant external
do
  virsh net-define /tmp/${NETWORK}.xml
  virsh net-autostart ${NETWORK}
  virsh net-start ${NETWORK}
done
