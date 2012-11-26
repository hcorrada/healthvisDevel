from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop

from application import app
from application.settings import DEBUG

def main(argv=None):
	port=int(argv[1])
	print 'Starting server on port %d' % port
	
	http_server = HTTPServer(WSGIContainer(app))
	try:
		http_server.listen(port)
		IOLoop.instance().start()
	except:
		return 1
	return 0
    
if __name__ == '__main__':
    import sys
    sys.exit(main(argv=sys.argv))