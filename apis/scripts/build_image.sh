#!/bin/bash

ENV=$1
IMAGE=$2
SHOULD_UPLOAD=$3

ECR_REPOSITORY_NAME=racoon-images-repository-dev

cd apis

source ./scripts/.build.$ENV.env

ECR_REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin $ECR_REPOSITORY_URI

if [ "$IMAGE" == "base" ]; then
    echo "Building base image..."

    docker build -t $ECR_REPOSITORY_NAME:base -f ./base.dockerfile .

    echo "Finished building base image."

    if [ $SHOULD_UPLOAD == "true" ]; then
      echo "Uploading base image..."
      
      docker tag $ECR_REPOSITORY_NAME:base $ECR_REPOSITORY_URI/$ECR_REPOSITORY_NAME:base

      docker push $ECR_REPOSITORY_URI/$ECR_REPOSITORY_NAME:base

      echo "Finished uploading base image."
    fi   
else 
    echo "Building $IMAGE API image..."

    cd functions/$IMAGE

    docker build -t $ECR_REPOSITORY_NAME:$IMAGE -f ./dockerfile.$IMAGE .

    if [ $SHOULD_UPLOAD == 'true' ]; then
        echo "Uploading $IMAGE API image..."

        docker tag $ECR_REPOSITORY_NAME:$IMAGE $ECR_REPOSITORY_URI/$ECR_REPOSITORY_NAME:$IMAGE

        docker push $ECR_REPOSITORY_URI/$ECR_REPOSITORY_NAME:$IMAGE

        echo "Finished uploading $IMAGE API image."
    fi
fi
