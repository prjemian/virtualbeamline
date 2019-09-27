#!/bin/bash

# download and build synApps

PARENT_DIR="/opt"

EPICS_HOST_ARCH=linux-x86_64
EPICS_ROOT="${PARENT_DIR}/epics-base"
PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"
SUPPORT="${PARENT_DIR}/synApps/support"
PATH="${PATH}:${SUPPORT}/utils"

cd ${PARENT_DIR}
# synApps 6.1 release
HASH=cc5adba5b8848c9cb98ab96768d668ae927d8859
wget https://raw.githubusercontent.com/EPICS-synApps/support/${HASH}/assemble_synApps.sh

# edit the script first!
sed -i s='/APSshare/epics/base-3.15.6'='/opt/epics-base'=g assemble_synApps.sh
# do NOT build these for linux-x86_64
sed -i s/'ALLENBRADLEY='/'#ALLENBRADLEY='/g assemble_synApps.sh && \
    sed -i s/'CAMAC='/'#CAMAC='/g assemble_synApps.sh && \
    sed -i s/'DAC128V='/'#DAC128V='/g assemble_synApps.sh && \
    sed -i s/'DELAYGEN='/'#DELAYGEN='/g assemble_synApps.sh && \
    sed -i s/'DXP='/'#DXP='/g assemble_synApps.sh && \
    sed -i s/'DXPSITORO='/'#DXPSITORO='/g assemble_synApps.sh && \
    sed -i s/'IP330='/'#IP330='/g assemble_synApps.sh && \
    sed -i s/'IPUNIDIG='/'#IPUNIDIG='/g assemble_synApps.sh && \
    sed -i s/'LOVE='/'#LOVE='/g assemble_synApps.sh && \
    sed -i s/'QUADEM='/'#QUADEM='/g assemble_synApps.sh && \
    sed -i s/'SOFTGLUE='/'#SOFTGLUE='/g assemble_synApps.sh && \
    sed -i s/'SOFTGLUEZYNQ='/'#SOFTGLUEZYNQ='/g assemble_synApps.sh && \
    sed -i s/'VME='/'#VME='/g assemble_synApps.sh && \
    sed -i s/'YOKOGAWA_DAS='/'#YOKOGAWA_DAS='/g assemble_synApps.sh
# done editing

# review
# echo # start ------------------- assemble_synApps.sh -------------------
# cat assemble_synApps.sh
# echo # end ------------------- assemble_synApps.sh -------------------

# # run the script now
bash assemble_synApps.sh

AREA_DETECTOR=${SUPPORT}/areaDetector-R3-7
# recommended edits: https://areadetector.github.io/master/install_guide.html
cd ${AREA_DETECTOR}/configure
cp EXAMPLE_RELEASE.local         RELEASE.local && \
    cp EXAMPLE_RELEASE_SUPPORT.local RELEASE_SUPPORT.local && \
    cp EXAMPLE_RELEASE_LIBS.local    RELEASE_LIBS.local && \
    cp EXAMPLE_RELEASE_PRODS.local   RELEASE_PRODS.local && \
    cp EXAMPLE_CONFIG_SITE.local     CONFIG_SITE.local && \
    sed -i s:'#ADSIMDETECTOR=':'ADSIMDETECTOR=':g RELEASE.local && \
    sed -i s:'#PVADRIVER=':'PVADRIVER=':g RELEASE.local && \
    sed -i s:'SUPPORT=/corvette/home/epics/devel':'SUPPORT=/opt/synApps/support':g RELEASE_SUPPORT.local && \
    sed -i s:'asyn-4-36':'asyn-R4-36':g RELEASE_LIBS.local && \
    sed -i s:'areaDetector-3-7':'areaDetector-R3-7':g RELEASE_LIBS.local && \
    sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.3':'EPICS_BASE=/opt/base-7.0.3':g RELEASE_LIBS.local && \
    sed -i s:'asyn-4-36':'asyn-R4-36':g RELEASE_PRODS.local && \
    sed -i s:'areaDetector-3-7':'areaDetector-R3-7':g RELEASE_PRODS.local && \
    sed -i s:'autosave-5-10':'autosave-R5-10':g RELEASE_PRODS.local && \
    sed -i s:'busy-1-7-2':'busy-R1-7-2':g RELEASE_PRODS.local && \
    sed -i s:'calc-3-7-3':'calc-R3-7-3':g RELEASE_PRODS.local && \
    sed -i s:'seq-2-2-5':'seq-2-2-6':g RELEASE_PRODS.local && \
    sed -i s:'sscan-2-11-3':'sscan-R2-11-3':g RELEASE_PRODS.local && \
    sed -i s:'devIocStats-3-1-16':'iocStats-3-1-16':g RELEASE_PRODS.local && \
    sed -i s:'EPICS_BASE=/corvette/usr/local/epics-devel/base-7.0.3':'EPICS_BASE=/opt/base-7.0.3':g RELEASE_PRODS.local
cd ${AREA_DETECTOR}/ADCore/iocBoot
cp EXAMPLE_commonPlugins.cmd           commonPlugins.cmd && \
    cp EXAMPLE_commonPlugin_settings.req   commonPlugin_settings.req && \
    sed -i s:'#NDPvaConfigure':'NDPvaConfigure':g commonPlugins.cmd && \
    sed -i s:'#dbLoadRecords("NDPva':'dbLoadRecords("NDPva':g commonPlugins.cmd && \
    sed -i s:'#startPVAServer':'startPVAServer':g commonPlugins.cmd
# done editing

cd ${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector
tar czf ${SUPPORT}/../iocSimDetector-3.7.tar.gz iocSimDetector

cd ${SUPPORT}
# archive the template IOC, for making new XXX IOCs
tar czf ${SUPPORT}/../xxx-R6-1.tar.gz xxx-R6-1
make -j2 all
make clean
