import threading, Queue, sys

from tornado.wsgi import WSGIContainer
from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop

from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
	return 'Hello World!'

def startTornado():
	http_server = HTTPServer(WSGIContainer(app))
	http_server.listen(5000)
	IOLoop.instance().start()

def stopTornado():
	IOLoop.instance().stop()

class Starter(threading.Thread):
	def __init__(self, bucket):
		super(Starter, self).__init__()
		self.bucket = bucket

	def run(self):
		try:
			startTornado()
		except Exception:
			self.bucket.put(sys.exc_info())


def main():
	bucket = Queue.Queue()
	thread_obj = Starter(bucket)
	thread_obj.start()
	thread_obj.join(2)

	stopTornado()

	try:
		exc = bucket.get(block=False)
	except Queue.Empty:
		pass
	else:
		exc_type, exc_object, exc_trace = exc
		print exc_type, exc_object
		return 1

	return 0

if __name__=='__main__':
	sys.exit(main())