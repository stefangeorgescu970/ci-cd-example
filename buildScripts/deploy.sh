#!/bin/bash

# Arguments received by script

# $1 - environment in which the Lambda Should be Deployed

echo "LOG - Importing required methods from helper files."

. ./buildScripts/helpers/functions/deploy_lambda.sh

echo "LOG - Finished importing."

deploy_env=$1
lambda_full_name="ci-cd-example-lambda-${deploy_env}"

if [ "${deploy_env}" == "dev" ]; then
  aws_profile="default"
else
  aws_profile="stg"
fi



deployLambda src "${lambda_full_name}" "${aws_profile}" eu-central-1