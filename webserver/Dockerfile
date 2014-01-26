# Dockerfile for simple python webserver
# Version 1.0
FROM docker-network-demo/python

MAINTAINER Lukas Pustina <lukas.pustina@centerdevice.com>

ADD webserver.py /opt/webserver/webserver.py

EXPOSE 8080

CMD /opt/webserver/webserver.py 8080 $MONGO_PORT_27017_TCP_ADDR $MONGO_PORT_27017_TCP_PORT

