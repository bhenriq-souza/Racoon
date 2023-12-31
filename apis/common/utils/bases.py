
from common.utils.logger import LoggerFactory

class BaseError(Exception):
    def __init__(self, message, status_code):
        self.message = message
        self.status_code = status_code

class BaseLambda(object):
    @classmethod
    def get_handler(cls, *args, **kwargs):  
        logger: LoggerFactory = kwargs['logger']
        def handler(event, context):
            return cls(logger).handler(event, context)
        return handler
    
    def handler(self, event, context):
        raise NotImplementedError('handler method must be implemented')