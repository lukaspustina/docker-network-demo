#!/usr/bin/python
#######################################################
#
# Author: Lukas Pustina
#         (lukas.pustina [at] centerdevice.com)
#
#########################################################
#
# Requires
# - python 2.6, pymongo
#
########################################################
#
# Test
# curl -X POST -H "Content-Type: application/json" -d '{"name":"Albert Einstein","birthday":"14.03.1879"}' http://localhost:8080
# curl -X POST -H "Content-Type: application/json" -d '{"name":"Werner Heisenberg","birthday":"05.12.1901"}' http://localhost:8080
# curl -X POST -H "Content-Type: application/json" -d '{"name":"Issac Newton","birthday":" 04.01.1643"}' http://localhost:8080
# curl -X POST -H "Content-Type: application/json" -d '{"name":"James Clerk Maxwell","birthday":"13.06.1831"}' http://localhost:8080
# curl http://localhost:8080
########################################################

import logging
import sys
from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import pymongo
import json

class ServerHandler(BaseHTTPRequestHandler):

    def do_POST(self):
        collection = self.server.context["mongo_collection"]

        data_len = int(self.headers['Content-Length'])
        data = self.rfile.read(data_len)
        json_data = json.loads(data)
        collection.insert(json_data)

        self.send_response(200)
        self.end_headers()


    def do_GET(self):
        collection = self.server.context["mongo_collection"]

        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        for e in collection.find():
            line = ", ".join( ["%s = %s" % (k,e[k]) for k in e.keys() if k != "_id"] )
            self.wfile.write("%s\n" % line)


class Server():

    def __init__(self, args):
        self.listen_port = int(args[1])
        mongodb_ip = args[2]
        mongodb_port = int(args[3])
        mongo_connection = pymongo.Connection(mongodb_ip, mongodb_port)
        mongo_db = mongo_connection.demo
        self.mongo_collection = mongo_db.birthdays

    def run( self ):
        logging.info("Started")
        try:
            server = HTTPServer(('', self.listen_port), ServerHandler)
            server.context = { "mongo_collection":self.mongo_collection }
            server.serve_forever()
        except KeyboardInterrupt:
            logging.info( "CTRL-C received, shutting down server" )
            server.socket.close()
        logging.info("Shut down")


if __name__ == '__main__':
    FORMAT = "%(asctime)-15s %(message)s"
    LOGLEVEL = logging.INFO
    logging.basicConfig(level=LOGLEVEL, format=FORMAT)

    server = Server(sys.argv)
    server.run()


