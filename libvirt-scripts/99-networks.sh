for net in ctlplane storage storage_mgmt internal_api tenant external
do
  virsh net-destroy $net
  virsh net-undefine $net
done
