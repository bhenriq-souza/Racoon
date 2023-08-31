from aws_lambda_powertools import Logger
from boto3.dynamodb.conditions import Key
from datetime import datetime

from common.model.User import User
from common.services.Encryption import EncryptionService
from common.utils.errors import ErrorCodes, AWSClientDynamoDBError, AWSClientError

class UsersRepository():
    encryption: EncryptionService

    def __init__(self, table: any, services: dict, logger: Logger):
        self.logger = logger
        self.table = table

        self.encryption = services.get('encryption')

        if not self.encryption:
            raise AWSClientError('Encryption service is not set', ErrorCodes.INTERNAL_SERVER_ERROR.value)
    
        if not self.table:
            raise AWSClientError('DynamoDB table is not set', ErrorCodes.INTERNAL_SERVER_ERROR.value)

    def get_user(self, email: str) -> User:
        try:
            items = self.table.query(
                KeyConditionExpression=Key('email').eq(email)
            )

            if not items['Items']:
                return None
            
            user = items['Items'][0]

            return User(user.get('email'), user.get('password'), user.get('create_at'), user.get('update_at'))
        except Exception as e:
            self.logger.exception(e)
            raise AWSClientDynamoDBError('Error while getting user', ErrorCodes.INTERNAL_SERVER_ERROR.value)

    def create(self, user: User) -> None:
        try:
            email = user.get('email')
            password = user.get('password')
            created_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            updated_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

            existing_student = self.get_user(email)

            if existing_student:
                raise AWSClientDynamoDBError('User already exists', ErrorCodes.UNPROCESSABLE_ENTITY.value)

            cipher_password = self.encryption.encrypt(password)
            
            self.table.put_item(
                Item={
                    'email': email,
                    'password': cipher_password,
                    'create_at': created_at,
                    'update_at': updated_at
                }
            )
        except Exception as e:
            self.logger.exception(e)
            raise AWSClientDynamoDBError('Error while creating user', ErrorCodes.INTERNAL_SERVER_ERROR.value)
