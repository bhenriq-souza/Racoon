
from common.utils.logger import LoggerFactory
from functions.say_hello.handler import SayHelloHandler

logger = LoggerFactory.get_logger('image_uploader')
handler = SayHelloHandler.get_handler(logger=logger)

def test_say_hello_success():
    event = {
        'name': 'World'
    }
    context = {}
    reponse = handler(event, context)
    assert reponse['statusCode'] == 200
    assert reponse['body'] == 'Hello, World!'

def test_say_hello_error():
    event = {}
    context = {}
    reponse = handler(event, context)
    assert reponse['statusCode'] == 500
    assert reponse['body'] == 'Error: name is required'
