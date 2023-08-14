from common.utils.bases import BaseLambda
from common.utils.errors import CustomKeyErrorError, ErrorsCode
from common.utils.logger import LoggerFactory

class SayHelloHandler(BaseLambda):
    def __init__(self, logger: LoggerFactory):
        self.logger = logger

    def handler(self, event, context):
        try:
            self.logger.info('Initializing Image Uploader Lambda')

            self.logger.info(f'Event: {event}')

            if 'name' not in event:
                raise CustomKeyErrorError('name is required')

            self.logger.info(f"Saying Hello to {event['name']}")

            name = event['name']
            msg = f'Hello, {name}!'
            resp = {
                'statusCode': 200,
                'body': msg
            }

            self.logger.info(f'Response: {resp}')
            
            return resp
        except (CustomKeyErrorError, AttributeError, UnboundLocalError) as e:
            if isinstance(e, AttributeError) or isinstance(e, Exception):
                self.logger.error(f'Error: {ErrorsCode.INTERNAL_SERVER_ERROR.value} {e.args[0]}')

                return {
                    'statusCode': ErrorsCode.INTERNAL_SERVER_ERROR.value,
                    'body': f'Error: {e.args[0]}'
                }

            self.logger.error(f'Error: {e.status_code.value} {e.args[0]}')

            return {
                'statusCode': e.status_code.value,
                'body': e.message
            }

logger = LoggerFactory.get_logger('image_uploader')
handler = SayHelloHandler.get_handler(logger=logger)

if __name__ == "__main__":
    event = {
        'name': 'World'
    }
    context = {}
    reponse = handler(event, context)
    print(reponse)