FROM public.ecr.aws/lambda/python:3.10

COPY common/services/* ./common/services/

COPY common/utils/* ./common/utils/
