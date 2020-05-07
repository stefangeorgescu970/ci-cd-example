#!/bin/bash

set -e

echo "LOG - Importing required methods from helper files."

. ./buildScripts/helpers/functions/deploy_lambda.sh
. ./buildScripts/helpers/functions/get_property_from_file.sh

echo "LOG - Finished importing."

function getLatestVersionFromS3 {
  versions=`aws s3api list-objects --bucket ${artifact_bucket} --prefix ${repository_key} --profile stg | jq --raw-output ".Contents | map(.Key) | flatten[]" | cut -d"/" -f2 | uniq | grep -v properties | sort -r `
  if [ "$hotfix_release" = "false" ]; then
    echo `echo $versions | tr " " "\n" | grep -v "_" | head -n 1`
  else
    echo `echo $VERSIONS | tr " " "\n" | grep "_" | head -n 1`
  fi
}

echo "LOG - Preparing to deploy to production. Fetching deployment information"

artifact_bucket="stefan-georgescu-deployment-artifacts"
repository_key="ci-cd-example"
deploy_property_file="deploy.properties"
lambda_base_name="ci-cd-example"
s3_address="s3://${artifact_bucket}/${repository_key}"

aws s3 cp "${s3_address}/${deploy_property_file}" ${deploy_property_file} --quiet --profile stg

echo "LOG - Received the following deployment information from artifact storage:"
cat ${deploy_property_file}

hotfix_release=$(getPropertyFromFile ${deploy_property_file} "HOTFIX_IN_PROGRESS")
version_to_release=$(getLatestVersionFromS3)

if [ "$TRAVIS" == "true" ]; then
  echo "LOG - Configuring local git for release tagging."
  git config --local user.name "travis-builder"
  git config --local user.email "contact@stefangeorgescu.com"
fi

echo "LOG - Tagging commit for realse with number ${version_to_release}"
git tag ${version_to_release}

echo "LOG - Fetching artifacts for release."
mkdir -p release
aws s3 cp "${s3_address}/${version_to_release}" release --recursive --quiet --profile stg

if [ "$hotfix_release" = "false" ]; then
  deployLambda release "${lambda_base_name}-prod" prod eu-central-1
else
  deployLambda release "${lambda_base_name}-prod" prod eu-central-1

  hotfix_release="false"
  latest_version_for_release=$(getLatestVersionFromS3)

  rm -rf release
  echo "LOG - Fetching artefacts from release version ${latest_version_for_release} to reconstruct staging environment."
  mkdir -p release
  aws s3 cp "${s3_address}/${latest_version_for_release}" release --recursive --quiet --profile stg

  deployLambda release "${lambda_base_name}-stg" stg eu-central-1
  echo "HOTFIX_IN_PROGRESS=false" > $deploy_property_file
  aws s3 cp ${deploy_property_file} "${s3_address}/${deploy_property_file}" --quiet --profile stg
fi