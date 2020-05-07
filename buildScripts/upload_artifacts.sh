#!/bin/bash

set -e

echo "LOG - Importing required constants from helper files."

. ./buildScripts/helpers/constants.sh

echo "LOG - Finished importing."

function getBranchReleaseVersion {
  echo "${TRAVIS_BRANCH}" | cut -d'/' -f2
}

echo "LOG - Starting Artefact Upload"

version_number=$(getBranchReleaseVersion)
echo "LOG - Uploading release with version number ${version_number}"

aws s3 cp release ${s3_address}/${version_number} --recursive --quiet --profile ${staging_profile}