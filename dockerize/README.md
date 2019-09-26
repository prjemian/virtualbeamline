# README.md

cheat sheet to run this pile of containers

```
docker network create --driver bridge virtualbeam
docker run -d --rm --entrypoint="caRepeater" --name="caRepeater" --net=virtualbeam kedokudo/virtualbeamline:base
docker run -dit --rm -e IOC_PREFIX='dkr1:' -e IOCNAME='dkr1' --net=virtualbeam --name="iocdkr1" kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash
docker run -dit --rm -e IOC_PREFIX='dkrSIM1:' --net=virtualbeam --name='iocdkrSIM1' kedokudo/virtualbeamline:ioc6iddsimdet /bin/bash
docker run -dit --rm -e IOC_PREFIX='dkr2:' -e IOCNAME='dkr2' --net=virtualbeam --name="iocdkr2" kedokudo/virtualbeamline:ioc6iddsimmtr /bin/bash
docker attach iocdkrSIM1
```

### publish to DockerHub

```
docker tag local-image:tagname new-repo:tagname
docker push new-repo:tagname

docker login --user prjemian
docker tag local-image:tagname prjemian/epics:tagname
docker push prjemian/epics:tagname
```

### ADSim

from: https://areadetector.github.io/master/install_guide.html#run-simdetector

```
cd ADSimDetector/iocs/simDetectorIOC/iocBoot/iocSimDetector
### Edit Makefile to set ARCH to your $(EPICS_HOST_ARCH) architecture
make
../../bin/linux-x86_64/simDetectorApp st.cmd

### If you want to be able to easily run Linux and Windows in the same tree do the following:
###   Set ARCH in Makefile for Linux, run make on the Linux machine, and copy envPaths to envPaths.linux
###   Set ARCH in Makefile for Windows, run make on the Windows machine, and copy envPaths to envPaths.windows
### Start the IOC for Linux:
../../bin/linux-x86_64/simDetectorApp st.cmd.linux
### Start the IOC for Windows:
```
