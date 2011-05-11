from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
import tornado.autoreload
import tornado.options
from distrivia import app



SSL_PORT = 443

ssl_files = {
 "certfile" : "ssl-cert/distrivia.lame.ws.crt",
 "keyfile"  : "ssl-cert/distrivia.lame.ws.key",
 "ca_certs" : "ssl-cert/distrivia.lame.ws.ca-bundle"
}

tornado.options.parse_command_line()

wsgiApp = WSGIContainer(app)
http_server = HTTPServer(wsgiApp, ssl_options=ssl_files)
http_server.listen(443)
IOLoop.instance().start()
