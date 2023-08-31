from boto3.session import Session

from common.utils.configs import Environment

class AWSClient():
    __session: Session = None
    profile_name: str = None
    region_name: str = None
    stage: str = None
    
    def __init__(self, environment: Environment):
        self.stage = environment.get('STAGE')
        self.profile_name = environment.get('AWS_PROFILE_NAME')
        self.region_name = environment.get('AWS_REGION_NAME', 'us-east-1')

        if not self.__session:
            self.__session = Session(
                profile_name=self.profile_name if self.stage == 'local' else None,
                region_name=self.region_name
            )
    
    def s3(self):
        return self.__session.resource('s3')
    
    def kms(self):
        return self.__session.client('kms')

    def dynamodb(self, table: str):
        return self.__session.resource(
            'dynamodb',
            endpoint_url= 'http://localhost:8000' if self.stage == 'local' else None
        ).Table(table)
