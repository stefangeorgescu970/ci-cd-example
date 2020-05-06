#!/bin/bash

# Arguments received by script

# $1 - environment in which the Lambda Should be Deployed

echo "LOG - Importing required methods from helper files."

. ./buildScripts/helpers/functions/deploy_lambda.sh

echo "LOG - Finished importing."

deployLambda src ci-cd-example-lambda-dev default eu-central-1