from aws_lambda_powertools import Logger

class LoggerFactory:
    _LOG = None

    @staticmethod
    def __create_logger(service: str, level: str = "DEBUG") -> Logger:
        """
        A private method that interacts with Powertools Logger.
        """
        custom_date_format = "%Y-%m-%d %H:%M:%S"

        if not LoggerFactory._LOG:
            LoggerFactory._LOG = Logger(
                service=service,
                level=level, 
                datefmt=custom_date_format
            )
        
        return LoggerFactory._LOG

    @staticmethod
    def get_logger(service: str, level: str = "DEBUG") -> Logger:
        """
        A static method called by other modules to initialize logger in
        their own module.
        """
        if not LoggerFactory._LOG:
            LoggerFactory._LOG = LoggerFactory.__create_logger(service, level)
        
        return LoggerFactory._LOG
