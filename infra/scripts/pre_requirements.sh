#!/bin/bash

REQUIRED_VERSION="1.3.9"
REQUIRED_TERRAGRUNT_VERSION="0.43.0"

# Check and install function
check_and_install() {
  TOOL_NAME=$1
  REQUIRED_VERSION=$2
  INSTALLED_VERSION_COMMAND=$3
  DOWNLOAD_URL=$4

  if ! command -v $TOOL_NAME &> /dev/null; then
    echo "$TOOL_NAME could not be found. Installing $TOOL_NAME $REQUIRED_VERSION..."
  else
    INSTALLED_VERSION=$($INSTALLED_VERSION_COMMAND)

    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$INSTALLED_VERSION" | sort -V | head -n 1)" = "$REQUIRED_VERSION" ]; then
      echo "$TOOL_NAME is installed with version $INSTALLED_VERSION, which meets the requirement."
      return
    else
      echo "You have $TOOL_NAME version $INSTALLED_VERSION. Installing $TOOL_NAME $REQUIRED_VERSION..."
    fi
  fi

  OS=$(uname -s | tr '[:upper:]' '[:lower:]')
  curl -LO $DOWNLOAD_URL

  # For Terragrunt, just download and provide execute permissions
  if [ "$TOOL_NAME" == "terragrunt" ]; then
    chmod +x "$TOOL_NAME"
    sudo mv $TOOL_NAME /usr/local/bin/
  else
    unzip "${TOOL_NAME}_${REQUIRED_VERSION}_${OS}_amd64.zip"
    sudo mv $TOOL_NAME /usr/local/bin/
    rm "${TOOL_NAME}_${REQUIRED_VERSION}_${OS}_amd64.zip"
  fi

  echo "$TOOL_NAME $REQUIRED_VERSION has been installed."
}

# Terraform
check_and_install "terraform" \
                  "$REQUIRED_TERRAFORM_VERSION" \
                  "terraform version | head -n 1 | cut -d ' ' -f 2 | sed 's/v//'" \
                  "https://releases.hashicorp.com/terraform/${REQUIRED_TERRAFORM_VERSION}/terraform_${REQUIRED_TERRAFORM_VERSION}_$(uname -s | tr '[:upper:]' '[:lower:]')_amd64.zip"

# Terragrunt
check_and_install "terragrunt" \
                  "$REQUIRED_TERRAGRUNT_VERSION" \
                  "terragrunt --version | cut -d ' ' -f 3" \
                  "https://github.com/gruntwork-io/terragrunt/releases/download/v${REQUIRED_TERRAGRUNT_VERSION}/terragrunt_$(uname -s | tr '[:upper:]' '[:lower:]')_amd64"
