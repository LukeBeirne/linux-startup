#!/usr/bin/env bash

ignore_errors=0

# Posix variable
OPTIND=1 # Reset in case getopts has been previously in the shell
while getopts "ih" opt; do
    case "$opt" in
    i) ignore_errors=1
        ;;
    h) echo "If this script is passed -i the errors will be ignored"
        exit 0
    esac
done

modprobe -r zfs > /dev/null 2>&1
modprobe -r spl > /dev/null 2>&1

if [ $ignore_errors -ne 1 ];
then
    lsmod | grep -w zfs
    if [ $? -ne 1 ];
    then
        echo "ZFS module could not be unloaded... Exiting."
        exit 1
    fi
    lsmod | grep -w spl
    if [ $? -ne 1 ];
    then
        echo "SPL module could not be unloaded... Exiting."
        exit 1
    fi
fi

echo "Removing ZFS rpm's"

for the_rpm_zfs in $(yum list installed | grep zfs | awk '{print $1}')
do
    yum remove -y $the_rpm_zfs > /dev/null 2>&1
done

echo "Removing libnvpair and libzpool"
for the_rpm in $(yum list installed | grep libnvpair | awk '{print $1}')
do
    yum remove -y $the_rpm > /dev/null 2>&1
done

echo "Removing uutil"
for the_rpm in $(yum list installed | grep uutil | awk '{print $1}')
do
    yum remove -y $the_rpm > /dev/null 2>&1
done

echo "Removing SPL rpm's"
for the_rpm_spl in $(yum list installed | grep spl | awk '{print $1}')
do
    yum remove -y $the_rpm_spl > /dev/null 2>&1
done

if [ $ignore_errors -ne 1 ];
then
    yum list installed | grep zfs
    if [ $? -ne 1 ];
    then
        echo "Some ZFS rpm's are still present... Exiting."
        exit 1
    fi
fi

if [ $ignore_errors -ne 1 ];
then
    yum list installed | grep nvpair
    if [ $? -ne 1 ];
    then
        echo "nvpair rpm are still present... Exiting."
        exit 1
    fi
    
    yum list installed | grep zpool
    if [ $? -ne 1 ];
    then
        echo "zpool rpm are still present... Exiting."
        exit 1
    fi
    
    yum list installed | grep uutil
    if [ $? -ne 1 ];
    then
        echo "uutil rpm are still present... Exiting."
        exit 1
    fi
fi

if [ $ignore_errors -ne 1 ];
then
    yum list installed | grep spl
    if [ $? -ne 1 ];
    then
        echo "Some SPL rpm's are still present... Exiting"
        exit 1
    fi
fi

echo Removing ko files from /lib/modules/$(uname -r)/extra
find /lib/modules/$(uname -r)/extra -name "splat.ko" -or -name "zcommon.ko" -or -name "zpios.ko" -or -name "spl.ko" -or -name "zavl.ko" -or -name "zfs.ko" -or -name "znvpair.ko" -or -name "zunicode.ko" | xargs rm -f

sleep 1

echo Removing ko files from /lib/modules/$(uname -r)/weak-updates
find /lib/modules/$(uname -r)/weak-updates -name "splat.ko" -or -name "zcommon.ko" -or -name "zpios.ko" -or -name "spl.ko" -or -name "zavl.ko" -or -name "zfs.ko" -or -name "znvpair.ko" -or -name "zunicode.ko" | xargs rm -f

echo Removing source directories
rm -fr /usr/src/zfs-*
rm -fr /usr/src/spl-*

sleep 1
echo All files have been removed
