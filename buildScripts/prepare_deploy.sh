#!/bin/bash

set -e

echo "LOG - Importing required constants from helper files."

. ./buildScripts/helpers/constants.sh

echo "LOG - Finished importing."

echo "LOG - Preparing Lambda for deployment."

./buildScripts/helpers/build.sh

if [[ $TRAVIS_BRANCH =~ (^release\/.*$|^hotfix\/.*$) ]]; then
  echo "LOG - Preparing release files."

  mkdir -p release
  cd src

  if [ -d dependencies ]; then
    cp dependencies/lambda_layer_deps.zip ../release/${lambda_base_name}-deps.zip
  fi

  cp lambda.zip ../release/${lambda_base_name}.zip

  cd ..
else
  echo "LOG - Skipping preparing files for release since we are on branch ${TRAVIS_BRANCH}."
fi