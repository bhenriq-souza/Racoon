#!/bin/bash

# Checks if the prerequisites are matched

cd infra

./scripts/pre_requirements.sh

ENVIRONMENT=$1
REGION=$2
RESOURCE=$3
SHOULD_APPLY=$4

export AWS_DEFAULT_REGION=$REGION
export AWS_PROFILE=personal

cd environments/$ENVIRONMENT/$REGION/$RESOURCE

echo "Initializing $RESOURCE in $ENVIRONMENT/$REGION"

terragrunt init --reconfigure

echo "Planning $RESOURCE in $ENVIRONMENT/$REGION"

terragrunt plan

echo "Done planning $RESOURCE in $ENVIRONMENT/$REGION"

if [ "$SHOULD_APPLY" = true ]; then
  echo "Applying $RESOURCE in $ENVIRONMENT/$REGION"

  terragrunt apply

  echo "Done applying $RESOURCE in $ENVIRONMENT/$REGION"
fi
