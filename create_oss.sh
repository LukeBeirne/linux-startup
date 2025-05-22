#!/bin/bash

mkdir -p /testdev/
dd if=/dev/zero of=/testdev/oss01 bs=1M count=0 seek=64

