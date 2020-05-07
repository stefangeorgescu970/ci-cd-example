#!/bin/bash

set -e

echo "LOG - Importing required methods and constants from helper files."

. ./buildScripts/helpers/functions/deploy_lambda.sh
. ./buildScripts/helpers/functions/get_property_from_file.sh
. ./buildScripts/helpers/constants.sh
. ./buildScripts/helpers/functions/get_latest_version_from_artifact_store.sh

echo "LOG - Finished importing."

echo "LOG - Preparing to deploy to production. Fetching deployment information"
aws s3 cp "${s3_address}/${deploy_property_file}" ${deploy_property_file} --quiet --profile ${staging_profile}

echo "LOG - Received the following deployment information from artifact storage:"
cat ${deploy_property_file}

hotfix_release=$(getPropertyFromFile ${deploy_property_file} "HOTFIX_IN_PROGRESS")
version_to_release=$(getLatestVersionFromArtifactStore ${artifact_bucket} ${repository_key} ${hotfix_release})

if [ "$TRAVIS" == "true" ]; then
  echo "LOG - Configuring local git for release tagging."
  git config --local user.name "travis-builder"
  git config --local user.email "contact@stefangeorgescu.com"
fi

echo "LOG - Tagging commit for realse with number ${version_to_release}"
git tag ${version_to_release}

echo "LOG - Fetching artifacts for release."
mkdir -p release
aws s3 cp "${s3_address}/${version_to_release}" release --recursive --quiet --profile ${staging_profile}

if [ "$hotfix_release" = "false" ]; then
  deployLambda release "${lambda_base_name}-prod" prod eu-central-1
else
  deployLambda release "${lambda_base_name}-prod" prod eu-central-1

  latest_version_for_release=$(getLatestVersionFromArtifactStore ${artifact_bucket} ${repository_key} "false")

  rm -rf release
  echo "LOG - Fetching artefacts from release version ${latest_version_for_release} to reconstruct staging environment."
  mkdir -p release
  aws s3 cp "${s3_address}/${latest_version_for_release}" release --recursive --quiet --profile ${staging_profile}

  deployLambda release "${lambda_base_name}-stg" stg eu-central-1
  echo "HOTFIX_IN_PROGRESS=false" > $deploy_property_file
  aws s3 cp ${deploy_property_file} "${s3_address}/${deploy_property_file}" --quiet --profile ${staging_profile}
fi