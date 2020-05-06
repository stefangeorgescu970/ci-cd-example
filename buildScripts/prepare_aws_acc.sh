#!/bin/bash

set -e

# Environment variables encrypted within Travis configuration.

# AWS_KEY_ID - id of the access key
# AWS_SECRET_KEY - secret key

# If statement added in case of accidental execution on local environment.

if [ "$TRAVIS" == "true" ]; then
  echo "LOG - Configuring AWS accounts."

  rm -f ~/.aws/config
  rm -f ~/.aws/credentials

  mkdir -p ~/.aws

  touch ~/.aws/config
  touch ~/.aws/credentials

  echo "[default]" >> ~/.aws/credentials
  echo "aws_access_key_id = ${AWS_KEY_ID}" >> ~/.aws/credentials
  echo "aws_secret_access_key = ${AWS_SECRET_KEY}" >> ~/.aws/credentials
fi
