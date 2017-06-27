#!/bin/bash -x
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm debian-test poweroff
vboxmanage unregistervm debian-test --delete
vboxmanage clonevm debian-starter --register --name debian-test
vboxmanage  modifyvm debian-test --natpf1 "ssh,tcp,,2022,,22"
vboxmanage startvm debian-test --type headless

YMD=`date +"%y%m%d-%h:%m"`
scp -P 2022 ./iiab-debian.sh localhost:/root/iiab-debian.sh
# execute the following remotely on the VM
ssh -p 2022 localhost '/root/iiab-debian.sh|tee -a /root/output.log'
scp -P 2022 localhost:/root/output.log ./$YMD-debian.log
