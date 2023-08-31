from json import loads
from os import environ
from aws_lambda_powertools import Logger
from aws_lambda_powertools.utilities.typing import LambdaContext

from common.repository.user import UsersRepository
from common.services.AwsClient import AWSClient
from common.services.Encryption import EncryptionService
from common.utils.bases import BaseLambda
from common.utils.configs import Environment
from common.utils.logger import LoggerFactory
from common.utils.sign_up import SignupUtils
from common.utils.errors import CustomKeyErrorError, InternalServerError, ErrorCodes

class SignupHandler(BaseLambda):
    signup_util: SignupUtils
    users_repository: UsersRepository

    def __init__(self, logger: Logger, repositories: dict, services: dict, utils: dict):
        self.logger = logger
        self.signup_util = utils.get('sign_up')
        self.users_repository = repositories.get('users')

        if not self.users_repository:
            raise InternalServerError('users repository is not set')
        
        if not self.signup_util:
            raise InternalServerError('sign up utils is not set')
    
    def handler(self, event: dict, context: LambdaContext) -> dict:
        try:
            self.logger.debug(f'Event: {event}')

            self.logger.info('Starting sign up process')

            body = loads(event.get('body'))

            if not self.signup_util.validate_sign_up(body):
                self.logger.info('Error: Invalid parameters')
                return {
                    'statusCode': ErrorCodes.BAD_REQUEST.value,
                    'body': 'Error: Invalid parameters'
                }
            
            self.logger.info('Creating user')

            self.users_repository.create(body)

            resp = {
                'statusCode': 201,
                'body': 'User created successfully'
            }

            self.logger.info(f'Response: {resp}')
            
            return resp
        except (CustomKeyErrorError, AttributeError, UnboundLocalError, InternalServerError) as e:
            if isinstance(e, AttributeError) or isinstance(e, Exception):
                self.logger.error(f'Error: {ErrorCodes.INTERNAL_SERVER_ERROR.value} {e.args[0]}')

                return {
                    'statusCode': ErrorCodes.INTERNAL_SERVER_ERROR.value,
                    'body': f'Error: {e.args[0]}'
                }

            self.logger.error(f'Error: {e.status_code.value} {e.args[0]}')

            return {
                'statusCode': e.status_code.value,
                'body': e.message
            }

logger = LoggerFactory.get_logger('racoon_sign_up')
environment = Environment(environ)
aws = AWSClient(environment)

users_table = aws.dynamodb(environment.get('USERS_TABLE', 'users'))

kms_service = aws.kms()
encryption = EncryptionService(kms_service, environment)

users_repository = UsersRepository(table=users_table, services={'encryption': encryption}, logger=logger)

signup_util = SignupUtils()

handler = SignupHandler.get_handler(
    logger=logger,
    repositories={'users': users_repository},
    services={},
    utils={'sign_up': signup_util}
)

if __name__ == "__main__":
    invalid_body_event = {'resource': '/{proxy+}', 'path': '/say-hello', 'httpMethod': 'POST', 'headers': {'Accept': '*/*', 'Accept-Encoding': 'gzip, deflate, br', 'Cache-Control': 'no-cache', 'CloudFront-Forwarded-Proto': 'https', 'CloudFront-Is-Desktop-Viewer': 'true', 'CloudFront-Is-Mobile-Viewer': 'false', 'CloudFront-Is-SmartTV-Viewer': 'false', 'CloudFront-Is-Tablet-Viewer': 'false', 'CloudFront-Viewer-ASN': '27699', 'CloudFront-Viewer-Country': 'BR', 'Content-Type': 'application/json', 'Host': 'zshjopafkb.execute-api.us-east-1.amazonaws.com', 'Postman-Token': '8bf5e204-2bd5-46d1-85b7-79b87e486229', 'User-Agent': 'PostmanRuntime/7.32.1', 'Via': '1.1 1f54e0037dde5a82d8f40e6c589584d6.cloudfront.net (CloudFront)', 'X-Amz-Cf-Id': 'M9295eb3fRofwU7bFMHNAtQ-X1HelT6Yj508DgCkgHrq60fcTd_MLw==', 'X-Amzn-Trace-Id': 'Root=1-64e4eb16-5f3f20791feedbda55dffae8', 'X-Forwarded-For': '189.78.91.121, 15.158.37.38', 'X-Forwarded-Port': '443', 'X-Forwarded-Proto': 'https'}, 'multiValueHeaders': {'Accept': ['*/*'], 'Accept-Encoding': ['gzip, deflate, br'], 'Cache-Control': ['no-cache'], 'CloudFront-Forwarded-Proto': ['https'], 'CloudFront-Is-Desktop-Viewer': ['true'], 'CloudFront-Is-Mobile-Viewer': ['false'], 'CloudFront-Is-SmartTV-Viewer': ['false'], 'CloudFront-Is-Tablet-Viewer': ['false'], 'CloudFront-Viewer-ASN': ['27699'], 'CloudFront-Viewer-Country': ['BR'], 'Content-Type': ['application/json'], 'Host': ['zshjopafkb.execute-api.us-east-1.amazonaws.com'], 'Postman-Token': ['8bf5e204-2bd5-46d1-85b7-79b87e486229'], 'User-Agent': ['PostmanRuntime/7.32.1'], 'Via': ['1.1 1f54e0037dde5a82d8f40e6c589584d6.cloudfront.net (CloudFront)'], 'X-Amz-Cf-Id': ['M9295eb3fRofwU7bFMHNAtQ-X1HelT6Yj508DgCkgHrq60fcTd_MLw=='], 'X-Amzn-Trace-Id': ['Root=1-64e4eb16-5f3f20791feedbda55dffae8'], 'X-Forwarded-For': ['189.78.91.121, 15.158.37.38'], 'X-Forwarded-Port': ['443'], 'X-Forwarded-Proto': ['https']}, 'queryStringParameters': None, 'multiValueQueryStringParameters': None, 'pathParameters': {'proxy': 'racoon_sign_up'}, 'stageVariables': None, 'requestContext': {'resourceId': 'kbimpw', 'resourcePath': '/{proxy+}', 'httpMethod': 'POST', 'extendedRequestId': 'KEmrjFloIAMFTiA=', 'requestTime': '22/Aug/2023:17:06:30 +0000', 'path': '/dev/say-hello', 'accountId': '284932821432', 'protocol': 'HTTP/1.1', 'stage': 'dev', 'domainPrefix': 'zshjopafkb', 'requestTimeEpoch': 1692723990435, 'requestId': 'c9f8e97d-5646-4c4e-857a-8166348920fd', 'identity': {'cognitoIdentityPoolId': None, 'accountId': None, 'cognitoIdentityId': None, 'caller': None, 'sourceIp': '189.78.91.121', 'principalOrgId': None, 'accessKey': None, 'cognitoAuthenticationType': None, 'cognitoAuthenticationProvider': None, 'userArn': None, 'userAgent': 'PostmanRuntime/7.32.1', 'user': None}, 'domainName': 'zshjopafkb.execute-api.us-east-1.amazonaws.com', 'apiId': 'zshjopafkb'}, 'body': '{\"email\": \"bhenriq.souza\", \"password\": \"teste\"}', 'isBase64Encoded': False}
    valid_body_event = {'resource': '/{proxy+}', 'path': '/say-hello', 'httpMethod': 'POST', 'headers': {'Accept': '*/*', 'Accept-Encoding': 'gzip, deflate, br', 'Cache-Control': 'no-cache', 'CloudFront-Forwarded-Proto': 'https', 'CloudFront-Is-Desktop-Viewer': 'true', 'CloudFront-Is-Mobile-Viewer': 'false', 'CloudFront-Is-SmartTV-Viewer': 'false', 'CloudFront-Is-Tablet-Viewer': 'false', 'CloudFront-Viewer-ASN': '27699', 'CloudFront-Viewer-Country': 'BR', 'Content-Type': 'application/json', 'Host': 'zshjopafkb.execute-api.us-east-1.amazonaws.com', 'Postman-Token': '8bf5e204-2bd5-46d1-85b7-79b87e486229', 'User-Agent': 'PostmanRuntime/7.32.1', 'Via': '1.1 1f54e0037dde5a82d8f40e6c589584d6.cloudfront.net (CloudFront)', 'X-Amz-Cf-Id': 'M9295eb3fRofwU7bFMHNAtQ-X1HelT6Yj508DgCkgHrq60fcTd_MLw==', 'X-Amzn-Trace-Id': 'Root=1-64e4eb16-5f3f20791feedbda55dffae8', 'X-Forwarded-For': '189.78.91.121, 15.158.37.38', 'X-Forwarded-Port': '443', 'X-Forwarded-Proto': 'https'}, 'multiValueHeaders': {'Accept': ['*/*'], 'Accept-Encoding': ['gzip, deflate, br'], 'Cache-Control': ['no-cache'], 'CloudFront-Forwarded-Proto': ['https'], 'CloudFront-Is-Desktop-Viewer': ['true'], 'CloudFront-Is-Mobile-Viewer': ['false'], 'CloudFront-Is-SmartTV-Viewer': ['false'], 'CloudFront-Is-Tablet-Viewer': ['false'], 'CloudFront-Viewer-ASN': ['27699'], 'CloudFront-Viewer-Country': ['BR'], 'Content-Type': ['application/json'], 'Host': ['zshjopafkb.execute-api.us-east-1.amazonaws.com'], 'Postman-Token': ['8bf5e204-2bd5-46d1-85b7-79b87e486229'], 'User-Agent': ['PostmanRuntime/7.32.1'], 'Via': ['1.1 1f54e0037dde5a82d8f40e6c589584d6.cloudfront.net (CloudFront)'], 'X-Amz-Cf-Id': ['M9295eb3fRofwU7bFMHNAtQ-X1HelT6Yj508DgCkgHrq60fcTd_MLw=='], 'X-Amzn-Trace-Id': ['Root=1-64e4eb16-5f3f20791feedbda55dffae8'], 'X-Forwarded-For': ['189.78.91.121, 15.158.37.38'], 'X-Forwarded-Port': ['443'], 'X-Forwarded-Proto': ['https']}, 'queryStringParameters': None, 'multiValueQueryStringParameters': None, 'pathParameters': {'proxy': 'racoon_sign_up'}, 'stageVariables': None, 'requestContext': {'resourceId': 'kbimpw', 'resourcePath': '/{proxy+}', 'httpMethod': 'POST', 'extendedRequestId': 'KEmrjFloIAMFTiA=', 'requestTime': '22/Aug/2023:17:06:30 +0000', 'path': '/dev/say-hello', 'accountId': '284932821432', 'protocol': 'HTTP/1.1', 'stage': 'dev', 'domainPrefix': 'zshjopafkb', 'requestTimeEpoch': 1692723990435, 'requestId': 'c9f8e97d-5646-4c4e-857a-8166348920fd', 'identity': {'cognitoIdentityPoolId': None, 'accountId': None, 'cognitoIdentityId': None, 'caller': None, 'sourceIp': '189.78.91.121', 'principalOrgId': None, 'accessKey': None, 'cognitoAuthenticationType': None, 'cognitoAuthenticationProvider': None, 'userArn': None, 'userAgent': 'PostmanRuntime/7.32.1', 'user': None}, 'domainName': 'zshjopafkb.execute-api.us-east-1.amazonaws.com', 'apiId': 'zshjopafkb'}, 'body': '{\"email\": \"teste@test.com\", \"password\": \"Teste@teste123\"}', 'isBase64Encoded': False}
    context = {}
    reponse = handler(valid_body_event, context)
    print(reponse)
