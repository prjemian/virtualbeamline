FROM  ubuntu:latest
LABEL version="1.0.0" \
      maintainer="prjemian <prjemian@gmail.com>" \
      lastupdate="2019-09-25"
USER  root
WORKDIR /home

# Install necessary libraries from offical repo
RUN apt update  -y && \
    apt upgrade -y && \
    apt install -y  build-essential libreadline-dev wget

# Get the latest version of EPICS
ENV EPICS_HOST_ARCH=linux-x86_64
ENV EPICS_ROOT="/opt/epics-base"
ENV PATH="${PATH}:${EPICS_ROOT}/bin/${EPICS_HOST_ARCH}"

#RUN echo EPICS_HOST_ARCH=${EPICS_HOST_ARCH}
#RUN echo EPICS_ROOT=${EPICS_ROOT}
#RUN echo PATH=${PATH}

WORKDIR ${EPICS_ROOT}/..
RUN wget https://epics.anl.gov/download/base/base-7.0.3.tar.gz
#RUN ls -lAFg base-7.0.3.tar.gz
RUN tar xzf base-7.0.3.tar.gz
RUN rm  base-7.0.3.tar.gz
RUN ln -s base-7.0.3 epics-base
WORKDIR ${EPICS_ROOT}
#RUN pwd
#RUN ls -lAFg
RUN make -j4 CFLAGS="-fPIC" CXXFLAGS="-fPIC"

RUN make clean
