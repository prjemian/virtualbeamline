# Use the EPICS base image
FROM prjemian/epics:epics-base-7.0.3
LABEL version="0.0.1" \
      maintainer="prjemian <prjemian@gmail.com>" \
      lastupdate="2019-09-25"
USER  root

# Install necessary libraries from offical repo
# * need the libusb (newer faster usb support)
# TODO: Really?  * need the x11 support -- not for synApps
    #    libx11-dev \
    #    x11-xserver-utils \
    #    xorg-dev \
    #    xvfb \
RUN \
    apt update  -y && \
    apt upgrade -y && \
    apt install -y  \
       git \
       libusb-dev \
       libusb-1.0-0-dev \
       re2c \
       screen \
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
RUN sed -i s/'ALLENBRADLEY='/'#ALLENBRADLEY='/g assemble_synApps.sh
# RUN sed -i s/'ALIVE='/'#ALIVE='/g assemble_synApps.sh
RUN sed -i s/'CAMAC='/'#CAMAC='/g assemble_synApps.sh
RUN sed -i s/'DAC128V='/'#DAC128V='/g assemble_synApps.sh
RUN sed -i s/'DELAYGEN='/'#DELAYGEN='/g assemble_synApps.sh
RUN sed -i s/'DXP='/'#DXP='/g assemble_synApps.sh
RUN sed -i s/'DXPSITORO='/'#DXPSITORO='/g assemble_synApps.sh
RUN sed -i s/'IP330='/'#IP330='/g assemble_synApps.sh
RUN sed -i s/'IPUNIDIG='/'#IPUNIDIG='/g assemble_synApps.sh
RUN sed -i s/'LOVE='/'#LOVE='/g assemble_synApps.sh
RUN sed -i s/'QUADEM='/'#QUADEM='/g assemble_synApps.sh
RUN sed -i s/'SOFTGLUE='/'#SOFTGLUE='/g assemble_synApps.sh
RUN sed -i s/'SOFTGLUEZYNQ='/'#SOFTGLUEZYNQ='/g assemble_synApps.sh
RUN sed -i s/'VME='/'#VME='/g assemble_synApps.sh
RUN sed -i s/'YOKOGAWA_DAS='/'#YOKOGAWA_DAS='/g assemble_synApps.sh
# done editing

# review
RUN echo # start ------------------- assemble_synApps.sh -------------------
RUN cat assemble_synApps.sh
RUN echo # end ------------------- assemble_synApps.sh -------------------

# # run the script now
RUN bash assemble_synApps.sh
# RUN mv synApps  synApps-6.1
# RUN ln -s synApps-6.1  synApps

WORKDIR ${SUPPORT}
RUN ls -lAFgh
# # edit a few things before build
# # done editing
RUN make clean release all
