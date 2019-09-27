# Use the EPICS base image
FROM prjemian/epics:epics-base-7.0.3
LABEL version="0.0.1" \
      maintainer="prjemian <prjemian@gmail.com>" \
      lastupdate="2019-09-26"
USER  root

# Install necessary libraries from offical repo
# * need the libusb (newer faster usb support)
# * area detector needs X11 (GraphicsMagick)
# * run IOCs in screen sessions
# * xvfb for remote GUI viewing
RUN \
    apt-get update  -y && \
    apt-get upgrade -y && \
    apt-get install -y  \
       git \
       libusb-dev \
       libusb-1.0-0-dev \
       libx11-dev \
       re2c \
       screen \
       x11-xserver-utils \
       xorg-dev \
       xvfb \
       && \
    rm -rf /var/lib/apt/lists/*

ENV EPICS_HOST_ARCH=linux-x86_64
ENV EPICS_ROOT="/opt/epics-base"
ENV PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"
ENV SYNAPPS_PARENT="/opt"
ENV SUPPORT="${SYNAPPS_PARENT}/synApps/support"
ENV PATH="${PATH}:${SUPPORT}/utils"

WORKDIR ${SYNAPPS_PARENT}
# synApps 6.1 release
ENV HASH=cc5adba5b8848c9cb98ab96768d668ae927d8859
RUN wget https://raw.githubusercontent.com/EPICS-synApps/support/${HASH}/assemble_synApps.sh

# edit the script first!
RUN sed -i s='/APSshare/epics/base-3.15.6'='/opt/epics-base'=g assemble_synApps.sh
# do NOT build these for linux-x86_64
RUN sed -i s/'ALLENBRADLEY='/'#ALLENBRADLEY='/g assemble_synApps.sh && \
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
RUN echo # start ------------------- assemble_synApps.sh -------------------
RUN cat assemble_synApps.sh
RUN echo # end ------------------- assemble_synApps.sh -------------------

# # run the script now
RUN bash assemble_synApps.sh

ENV AREA_DETECTOR=${SUPPORT}/areaDetector-R3-7
WORKDIR ${SUPPORT}
# RUN ls -lAFgh

# recommended edits: https://areadetector.github.io/master/install_guide.html
WORKDIR ${SUPPORT}/areaDetector-R3-7/configure
RUN cp EXAMPLE_RELEASE.local         RELEASE.local && \
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
WORKDIR ${SUPPORT}/areaDetector-R3-7/ADCore/iocBoot
RUN cp EXAMPLE_commonPlugins.cmd           commonPlugins.cmd && \
    cp EXAMPLE_commonPlugin_settings.req   commonPlugin_settings.req && \
    sed -i s:'#NDPvaConfigure':'NDPvaConfigure':g commonPlugins.cmd && \
    sed -i s:'#dbLoadRecords("NDPva':'dbLoadRecords("NDPva':g commonPlugins.cmd && \
    sed -i s:'#startPVAServer':'startPVAServer':g commonPlugins.cmd
# done editing

WORKDIR ${AREA_DETECTOR}/ADSimDetector/iocs/simDetectorIOC/iocBoot
RUN tar czf ${SUPPORT}/../iocSimDetector-3.7.tar.gz iocSimDetector

WORKDIR ${SUPPORT}
# archive the template IOC, for making new XXX IOCs
RUN tar czf ${SUPPORT}/../xxx-R6-1.tar.gz xxx-R6-1
RUN make -j2 all && \
    make clean
