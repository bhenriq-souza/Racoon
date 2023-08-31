
from os import _Environ

class Environment():
    def __init__(self, environ: _Environ[str]):
        self.__environ = environ

    def get(self, key, default=None):
        return self.__environ.get(key, default)