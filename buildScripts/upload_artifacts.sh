#!/bin/bash

set -e

function getBranchReleaseVersion {
  echo "${TRAVIS_BRANCH}" | cut -d'/' -f2
}

echo "LOG - Starting Artefact Upload"

artifact_bucket="stefan-georgescu-deployment-artifacts"
repository_key="ci-cd-example"
s3_address="s3://${artifact_bucket}/${repository_key}"

version_number=$(getBranchReleaseVersion)
echo "LOG - Uploading release with version number ${version_number}"

aws s3 cp release ${s3_address}/${version_number} --recursive --quiet --profile stg