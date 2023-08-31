
from re import match

class SignupUtils(object):
    def __init__(self) -> None:
        pass

    def __validate_password(self, password: str) -> None:
        pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?~\\/-]).{8,}$'
        return bool(match(pattern, password))

    def __validate_email(self, email: str) -> None:
        pattern = r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}+\.[a-zA-Z]{2,}$'
        return bool(match(pattern, email))

    def validate_sign_up(self, body: dict) -> None:
        if 'email' not in body or 'password' not in body:
            return False
        
        if  not self.__validate_password(body['password']) and not self.__validate_email(body['email']):
            return False

        return True
