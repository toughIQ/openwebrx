#!/bin/bash
set -euxo pipefail
export MAKEFLAGS="-j4"

function cmakebuild() {
  cd $1
  if [[ ! -z "${2:-}" ]]; then
    git checkout $2
  fi
  mkdir build
  cd build
  cmake ..
  make
  make install
  cd ../..
  rm -rf $1
}

cd /tmp

STATIC_PACKAGES="libusb-1.0.0"
BUILD_PACKAGES="git libusb-1.0.0-dev cmake make gcc g++ pkg-config"

apt-get update
apt-get -y install --no-install-recommends $STATIC_PACKAGES $BUILD_PACKAGES

#git clone https://github.com/osmocom/rtl-sdr.git
## latest from master as of 2020-09-04
#cmakebuild rtl-sdr ed0317e6a58c098874ac58b769cf2e609c18d9a5
apt-get install -y rtl-sdr

apt-get -y purge --autoremove $BUILD_PACKAGES
apt-get clean
rm -rf /var/lib/apt/lists/*
