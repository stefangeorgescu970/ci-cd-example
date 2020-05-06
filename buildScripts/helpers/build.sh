#!/bin/bash

echo "LOG - Importing required methods from helper files."

. ./buildScripts/helpers/functions/build_lambda.sh

echo "LOG - Finished importing."

buildLambda src

