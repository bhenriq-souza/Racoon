import logging

class LoggerFactory(object):
    _LOG = None

    @staticmethod
    def __create_logger(log_handler):
        """
        A private method that interacts with the python
        logging module
        """
        # set the logging format
        log_format = "%(asctime)s: %(levelname)s: %(message)s"
        
        # Initialize the class variable with logger object
        LoggerFactory._LOG = logging.getLogger(log_handler)
        logging.basicConfig(level=logging.DEBUG, format=log_format, datefmt="%Y-%m-%d %H:%M:%S")

        return LoggerFactory._LOG

    @staticmethod
    def get_logger(log_handler):
        """
        A static method called by other modules to initialize logger in
        their own module
        """
        logger = LoggerFactory.__create_logger(log_handler)
        
        # return the logger object
        return logger