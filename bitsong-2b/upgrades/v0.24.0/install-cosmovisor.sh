#!/bin/sh
git clone -b feat/cosmovisor-preupgradescript https://github.com/permissionlessweb/cosmos-sdk cv-cosmos-sdk
# traverse into cosmovisor root
cd cv-cosmos-sdk/tools/cosmovisor || exit
# build cosmovisor image manually
make cosmovisor
# move binary into system-wide user binary directory
mv cosmovisor /usr/local/bin/
# cleanup workspace
cd ../../../ && rm -rf cv-cosmos-sdk

