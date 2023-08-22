#!/bin/bash

ENV=$1
IMAGE=$2
SHOULD_UPLOAD=$3

ECR_REPOSITORY_NAME=racoon-images-repository-$ENV

cd apis

source ./scripts/.build.$ENV.env

ECR_REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin $ECR_REPOSITORY_URI

if [ "$IMAGE" == "base" ]; then
    echo "Building base image..."

    docker build -t $ECR_REPOSITORY_NAME:racoon_apis_base -f ./base.dockerfile .

    echo "Finished building base image."

    if [ $SHOULD_UPLOAD == "true" ]; then
      echo "Uploading base image..."
      
      docker tag $ECR_REPOSITORY_NAME:racoon_apis_base $ECR_REPOSITORY_URI/$ECR_REPOSITORY_NAME:racoon_apis_base

      docker push $ECR_REPOSITORY_URI/$ECR_REPOSITORY_NAME:racoon_apis_base

      echo "Finished uploading base image."
    fi
else 
    echo "Building $IMAGE API image..."

    FUNCTION_NAME="racoon_"$IMAGE"_function"

    cd functions/$IMAGE

    docker build -t $ECR_REPOSITORY_NAME:racoon_$IMAGE -f ./dockerfile.$IMAGE .

    if [ $SHOULD_UPLOAD == 'true' ]; then
        echo "Uploading $IMAGE API image..."

        IMAGE_URI=$ECR_REPOSITORY_URI/$ECR_REPOSITORY_NAME:'racoon_'$IMAGE

        docker tag $ECR_REPOSITORY_NAME:racoon_$IMAGE $IMAGE_URI

        docker push $IMAGE_URI
        
        echo "Updating API image for $FUNCTION_NAME function using $IMAGE_URI and $AWS_REGION region"

        aws lambda update-function-code \
          --function-name $FUNCTION_NAME \
          --image-uri $IMAGE_URI \
          --region $AWS_REGION \
          --profile personal

        echo "Finished uploading $IMAGE API image."
    fi
fi
