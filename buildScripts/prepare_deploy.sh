#!/bin/bash

set -e

echo "LOG - Preparing Lambda for deployment."

./buildScripts/helpers/build.sh

if [[ $TRAVIS_BRANCH =~ (^release\/.*$) ]]; then
  echo "LOG - Preparing release files."

  mkdir -p release
  cd src

  if [ -d dependencies ]; then
    cp dependencies/lambda_layer_deps.zip ../release/ci-cd-example-lambda-deps.zip
  fi

  cp lambda.zip ../release/ci-cd-example-lambda.zip

  cd ..
else
  echo "LOG - Skipping preparing files for release since we are on branch ${TRAVIS_BRANCH}."
fi