#!/bin/bash

echo "LOG - Importing required methods from helper files."

. ./buildScripts/helpers/functions/deploy_lambda.sh

echo "LOG - Finished importing."

deployLambda src dev default ci-cd-example