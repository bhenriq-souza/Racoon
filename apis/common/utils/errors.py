from enum import Enum

from common.utils.bases import BaseError

class ErrorCodes(Enum):
    BAD_REQUEST = 400
    UNAUTHORIZED = 401
    NOT_FOUND = 404
    PRE_CONDITION_FAILED = 412
    INTERNAL_SERVER_ERROR = 500
    RUNTIME_ERROR = 600
    UNPROCESSABLE_ENTITY = 422
   
class BadRequestError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorCodes.BAD_REQUEST.value)

class UnauthorizedError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorCodes.UNAUTHORIZED.value)

class NotFoundError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorCodes.NOT_FOUND.value)

class PreConditionFailedError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorCodes.PRE_CONDITION_FAILED.value)

class InternalServerError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorCodes.INTERNAL_SERVER_ERROR.value)

class CustomKeyErrorError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorCodes.RUNTIME_ERROR.value)

class AWSClientError(BaseError):
    def __init__(self, message):
        super().__init__(message, ErrorCodes.INTERNAL_SERVER_ERROR.value)

class AWSClientDynamoDBError(BaseError):
    def __init__(self, message, status_code):
        super().__init__(message, status_code)

class AWSClientKmsError(BaseError):
    def __init__(self, message, status_code):
        super().__init__(message, status_code)
