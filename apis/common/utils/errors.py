from enum import Enum

from common.utils.bases import BaseError

class ErrorsCode(Enum):
    BAD_REQUEST = 400
    UNAUTHORIZED = 401
    NOT_FOUND = 404
    PRE_CONDITION_FAILED = 412
    INTERNAL_SERVER_ERROR = 500
    RUNTIME_ERROR = 600
   
class BadRequestError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorsCode.BAD_REQUEST.value)

class UnauthorizedError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorsCode.UNAUTHORIZED.value)

class NotFoundError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorsCode.NOT_FOUND.value)

class PreConditionFailedError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorsCode.PRE_CONDITION_FAILED.value)

class InternalServerError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorsCode.INTERNAL_SERVER_ERROR.value)

class CustomKeyErrorError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorsCode.RUNTIME_ERROR.value)

class AWSClientError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorsCode.INTERNAL_SERVER_ERROR.value)