#!/usr/bin/env bash

zfs_path=/home/brian/zfs

export PATH=$zfs_path:$PATH

for d in `find $zfs_path/cmd -maxdepth 1 -type d`
do
    export PATH=$d:$PATH
done

for d in `find $zfs_path/man -maxdepth 1 -type d`
do
    export MANPATH=$d:$MANPATH
done

export PATH=$zfs_path/scripts:$PATH
