#!/bin/bash

if [ -z "$name" ]; then
  echo "VM name was not specified ex: use Windows7 and put .vdi inside vbox folder."
  exit 0
fi

cd /vbox

VM=$name

VBoxManage createvm --name $VM --ostype "${VM}" --register

VBoxManage storagectl $VM --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $VM --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium $VM.vdi

VBoxManage storagectl $VM --name "IDE Controller" --add ide

VBoxManage storageattach $VM --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium none

VBoxManage modifyvm $VM --ioapic on
VBoxManage modifyvm $VM --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $VM --memory 2048 --vram 128
VBoxManage modifyvm $VM --nic1 bridged --bridgeadapter1 eth0

VBoxHeadless -s $VM