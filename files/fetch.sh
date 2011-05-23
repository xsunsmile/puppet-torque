#!/bin/bash

version="2.5.5"
repo_url="http://www.clusterresources.com/downloads/torque"
wget $repo_url/torque-$version.tar.gz
tar zxvf torque-$version.tar.gz 2>&1 >/dev/null
[ -e torque-$version.tar.gz ] && rm -rf torque-$version.tar.gz
mv torque-$version torque
