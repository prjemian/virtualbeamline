#!/bin/bash

# download and build EPICS base
PARENT_DIR="/opt"

# Get the latest version of EPICS
EPICS_HOST_ARCH=linux-x86_64
EPICS_ROOT="${PARENT_DIR}/epics-base"
PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"

cd ${PARENT_DIR}
wget https://epics.anl.gov/download/base/base-7.0.3.tar.gz
tar xzf base-7.0.3.tar.gz
/bin/rm  base-7.0.3.tar.gz
ln -s base-7.0.3 epics-base
cd ${EPICS_ROOT}

make -j4 CFLAGS="-fPIC" CXXFLAGS="-fPIC"

make clean
