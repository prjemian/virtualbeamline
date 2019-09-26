
ORG=prjemian
REPO=epics
TAG=synApps-6.1
LOGFILE=build-log.txt
NET=virtualbeam

FULLNAME=$(ORG)/$(REPO):$(TAG)

build ::
	docker build -t $(FULLNAME)  ./  2>&1 | tee $(LOGFILE)

run ::
	docker run -it --rm --net=$(NET) $(FULLNAME) /bin/bash

