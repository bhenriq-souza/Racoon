
from base64 import b64encode, b64decode
from botocore.exceptions import ClientError

from common.utils.configs import Environment
from common.utils.errors import AWSClientKmsError, ErrorCodes

class EncryptionService(object):
    def __init__(self, kms, environment: Environment) -> None:
        self.kms = kms
        self.key_alias = environment.get('KMS_USERS_KEY_ALIAS')
    
    def encrypt(self, text: str) -> str:
        try:
            if not self.key_alias:
                raise AWSClientKmsError('Kms key alias is not set', ErrorCodes.UNPROCESSABLE_ENTITY.value)
        
            cipher_text = self.kms.encrypt(
                KeyId=self.key_alias,
                Plaintext=text
            )

            return b64encode(cipher_text["CiphertextBlob"])
        except ClientError as e:
            raise e        

    def decrypt(self, cipher_text: str) -> str:
        try:
            if not self.key_alias:
                raise AWSClientKmsError('Kms key alias is not set', ErrorCodes.UNPROCESSABLE_ENTITY.value)
        
            plain_text = self.kms.decrypt(
                KeyId=self.key_alias,
                CiphertextBlob=bytes(b64decode(cipher_text))
            )

            return plain_text["Plaintext"]
        except ClientError as e:
            raise e
