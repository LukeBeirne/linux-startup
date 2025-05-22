#!/bin/bash

ipadd="192.168.56.102"

modprobe lustre
modprobe zfs
# make necessary dirs
mkdir -p /mnt/lustre/{mgt,mds00.mdt0,oss00.ost0,oss00.ost1,oss01.ost0,oss01.ost1}

# MGT and MDTs
zpool create -f lustre-mgs /testdev/mgs
zpool create -f lustre-mds00 /testdev/mds00

mkfs.lustre --reformat --mgs --backfstype=zfs --fsname=lustre lustre-mgs/mgt
mkfs.lustre --reformat --mdt --mgsnode=$ipadd --backfstype=zfs --fsname=lustre --index=0 lustre-mds00/mdt0

mount -t lustre lustre-mgs/mgt /mnt/lustre/mgt
mount -t lustre lustre-mds00/mdt0 /mnt/lustre/mds00.mdt0

# OSSs and OSTs
zpool create -f lustre-oss00 /testdev/oss00
zpool create -f lustre-oss01 /testdev/oss01

# OSS00
mkfs.lustre --reformat --ost --backfstype=zfs --fsname=lustre --index=0 --mgsnode=$ipadd lustre-oss00/ost0
mkfs.lustre --reformat --ost --backfstype=zfs --fsname=lustre --index=1 --mgsnode=$ipadd lustre-oss00/ost1

mount -t lustre lustre-oss00/ost0 /mnt/lustre/oss00.ost0
mount -t lustre lustre-oss00/ost1 /mnt/lustre/oss00.ost1

# OSS01
mkfs.lustre --reformat --ost --backfstype=zfs --fsname=lustre --index=2 --mgsnode=$ipadd lustre-oss01/ost0
mkfs.lustre --reformat --ost --backfstype=zfs --fsname=lustre --index=3 --mgsnode=$ipadd lustre-oss01/ost1

mount -t lustre lustre-oss01/ost0 /mnt/lustre/oss01.ost0
mount -t lustre lustre-oss01/ost1 /mnt/lustre/oss01.ost1

