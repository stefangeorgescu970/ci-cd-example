#!/bin/bash

# Received parameters

# $1 - Lambda path compared to current working directory
# $2 - AWS environment in which to deploy lambda
# $3 - AWS profile to use with the aws cli
# $4 - name of lambda function without the environment

function deployLambda {
  set -e
  
  lambda_path=$1
  deploy_env=$2
  aws_profile=$3
  lambda_name=$4

  echo "LOG - Deploying Lambda ${lambda_name} to AWS in ${deploy_env} environment with profile ${aws_profile}"

  export AWS_PROFILE=${aws_profile}

  lambda_full_name="${lambda_name}-${deploy_env}"

  cd "${lambda_path}"

  if [ -d dependencies ]; then
    echo "LOG - Found Lambda dependencies. Creating Lambda Layer."

    layer_version_arn=$(aws lambda publish-layer-version --layer-name "${lambda_name}-dependencies-${deploy_env}" --zip-file fileb://./dependencies/lambda_layer_deps.zip --compatible-runtimes python3.8 | jq -r .LayerVersionArn)
    aws lambda update-function-configuration --function-name "${lambda_full_name}" --layers ${layer_version_arn}
  fi

  echo "LOG - Updating function code."
  aws lambda update-function-code --function-name "${lambda_full_name}" --zip-file fileb://./lambda.zip

}