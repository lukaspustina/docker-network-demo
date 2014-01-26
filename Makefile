LOGDIR=logs

.PHONY: base mongodb python webserver


all:
	@echo "make build -- build docker images"
	@echo "make run -- run container"
	@echo "make demo -- execute demo"

$(LOGDIR):
	@mkdir -p $@

build: base mongodb python webserver
	docker images

base:
	docker build -no-cache -rm -t docker-network-demo/$@ $@

mongodb:
	docker build -no-cache -rm -t docker-network-demo/$@ $@

python:
	docker build -no-cache -rm -t docker-network-demo/$@ $@

webserver:
	docker build -no-cache -rm -t docker-network-demo/$@ $@

run: $(LOGDIR) pipework
	@echo "+++ Starting containers +++"
	docker run -d -cidfile=$</mongodb.cid -name mongodb docker-network-demo/mongodb:latest
	docker run -d -cidfile=$</webserver.cid -link mongodb:mongo -p 8080:8080 -name webserver docker-network-demo/webserver:latest
	sudo ./pipework docker0 -i eth1 $$(docker ps -q -l) 10.2.0.11/16
	@echo "+++ Running containers +++"
	@docker ps

getWebserverIP = docker inspect webserver | grep IPAddress | awk '{print $$2}' | tr -d '",\n'

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
	-@docker ps -q | xargs docker kill > /dev/null
	-@docker ps -a -q | xargs docker rm > /dev/null
	-@rm $</*.cid

clean: clean-logs clean-images

clean-logs:
	-@rm -rf $(LOGDIR)

clean-images:
	-@docker images -q | xargs docker rmi

pipework:
	curl https://raw.github.com/jpetazzo/pipework/master/pipework -o $@
	chmod +x $@

