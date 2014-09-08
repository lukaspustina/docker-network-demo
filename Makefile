LOGDIR=logs

.PHONY: base mongodb python webserver


all:
	@echo "make build -- build docker images"
	@echo "make run -- run container"
	@echo "make demo -- execute demo"
	@echo "make stop -- stop and remove all containers"

$(LOGDIR):
	@mkdir -p $@

build: base mongodb python webserver
	docker images

base:
	docker build --no-cache --force-rm -t lukaspustina/docker_network_demo_$@ $@

mongodb:
	docker build --no-cache --force-rm -t lukaspustina/docker_network_demo_$@ $@

python:
	docker build --no-cache --force-rm -t lukaspustina/docker_network_demo_$@ $@

webserver:
	docker build --no-cache --force-rm -t lukaspustina/docker_network_demo_$@ $@

run: $(LOGDIR) pipework
	@echo "+++ Starting containers +++"
	docker run -d --cidfile=$</mongodb.cid --name=mongodb --hostname=mongodb lukaspustina/docker_network_demo_mongodb:latest
	docker run -d --cidfile=$</webserver.cid --link=mongodb:mongo --publish=8080:8080 --name=webserver --hostname=webserver lukaspustina/docker_network_demo_webserver:latest
	sudo ./pipework docker0 -i eth1 $$(docker ps -q -l) 10.2.0.11/16
	@echo "+++ Running containers +++"
	@docker ps

getWebserverIP = docker inspect -f '{{ .NetworkSettings.IPAddress }}' webserver

demo:
	@echo "+++ Inserting Birthdays +++"
	@/bin/echo -ne "+ Posting to docker container IP: "
	curl -X POST -H "Content-Type: application/json" -d '{"name":"James Clerk Maxwell","birthday":"13.06.1831"}' http://$(shell $(getWebserverIP)):8080
	@/bin/echo -ne "+ Posting to host IP: "
	curl -X POST -H "Content-Type: application/json" -d '{"name":"Albert Einstein","birthday":"14.03.1879"}' http://10.2.0.10:8080
	@/bin/echo -ne "+ Posting to additional docker container IP: "
	curl -X POST -H "Content-Type: application/json" -d '{"name":"Werner Heisenberg","birthday":"05.12.1901"}' http://10.2.0.11:8080
	@echo "+++ Querying Birthdays +++"
	curl http://$(shell $(getWebserverIP)):8080

stop: $(LOGDIR)
	-@docker ps | grep lukaspustina/docker_network_demo_ | awk '{ print $$1 }' | xargs docker kill > /dev/null
	-@docker ps -a | grep lukaspustina/docker_network_demo_ | awk '{ print $$1 }' | xargs docker rm > /dev/null
	-@rm $</*.cid

clean: clean-logs clean-images

clean-logs:
	-@rm -rf $(LOGDIR)

clean-images:
	-@docker images -q | xargs docker rmi

pipework:
	wget https://raw.github.com/jpetazzo/pipework/master/pipework
	chmod +x $@

