
ORG=prjemian
REPO=epics
TAG=synApps-6.1
LOGFILE=build-log.txt
NET=virtualbeam

FULLNAME=$(ORG)/$(REPO):$(TAG)

build ::
	docker build -t $(FULLNAME)  ./  2>&1 | tee $(LOGFILE)

shell ::
	docker run -it --rm --net=$(NET) $(FULLNAME) /bin/bash

push ::
	docker push $(FULLNAME)

net ::
	docker network create --driver bridge $(NET)
