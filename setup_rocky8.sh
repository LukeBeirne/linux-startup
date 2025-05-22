#!/bin/bash

# Install openmpi
sudo dnf install -y openmpi
openmpi_path="/usr/lib64/openmpi/bin"
export PATH="$openmpi_path:$PATH"

echo "# Access to OpenMPI functions" >> ~/.bashrc
echo "export PATH=$openmpi_path:$PATH" >> ~/.bashrc

# Install FIO
sudo dnf install -y fio

# Install IOR and MDTEST
sudo dnf install -y openmpi-devel git automake
git clone https://github.com/hpc/ior .
cd ior
./bootstrap
./configure
make clean && make

ior_path="./ior/src"
echo "# Access to IOR and MDTEST" >> ~/.bashrc
echo "export PATH=$ior_path:$PATH" >> ~/.bashrc

