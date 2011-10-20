#!/bin/bash

version="2.5.5"
repo_url="http://www.clusterresources.com/downloads/torque"
wget -t 1 --connect-timeout=10 $repo_url/torque-$version.tar.gz
if [ -e torque-$version.tar.gz ]; then
  tar zxf torque-$version.tar.gz 2>&1 >/dev/null
  rm -rf torque-$version.tar.gz
  mv torque-$version torque
fi
[ ! -e torque ] && git clone https://github.com/xsunsmile/lrm-torque-clone.git torque
exit 0
