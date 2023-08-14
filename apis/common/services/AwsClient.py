from boto3.session import Session

from common.utils.configs import Environment
from common.utils.errors import CustomKeyErrorError

class AWSClient():
    __session = None
    
    def __init__(self, environment: Environment):
        profile_name = environment.get('AWS_PROFILE_NAME')

        if not profile_name:
            raise CustomKeyErrorError('AWS_PROFILE_NAME is not set')

        if not self.__session:
            self.__session = Session(profile_name=profile_name)
    
    def s3(self):
        return self.__session.client('s3')
    
    def dynamodb(self):
        return self.__session.client('dynamodb')

