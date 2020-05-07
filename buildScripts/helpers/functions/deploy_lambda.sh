#!/bin/bash

# Received parameters

# $1 - Lambda path compared to current working directory
# $2 - name of lambda function
# $3 - AWS profile to use with the aws cli
# $4 - AWS region

function deployLambda {
  set -e
  
  lambda_path=$1
  lambda_name=$2
  aws_profile=$3
  aws_region=$4

  echo "LOG - Deploying Lambda ${lambda_name} to AWS with profile ${aws_profile}"

  export AWS_PROFILE=${aws_profile}
  export AWS_DEFAULT_REGION=${aws_region}

  cd "${lambda_path}"

  if [ -d dependencies ]; then
    echo "LOG - Found Lambda dependencies. Creating Lambda Layer."

    layer_version_arn=$(aws lambda publish-layer-version --layer-name "dependencies-${lambda_name}" --zip-file fileb://./dependencies/lambda_layer_deps.zip --compatible-runtimes python3.8 | jq -r .LayerVersionArn)
    aws lambda update-function-configuration --function-name "${lambda_name}" --layers ${layer_version_arn}
  fi

  echo "LOG - Updating function code."
  aws lambda update-function-code --function-name "${lambda_name}" --zip-file fileb://./lambda.zip

}