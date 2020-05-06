#!/bin/bash

# Received parameters

# $1 - Lambda path compared to current working directory

function buildLambda {
  set -e

  lambda_path=$1

  cd "${lambda_path}"

  echo "LOG - Beginning Lambda Packaging."

  req_file="requirements.txt"
  current_dir=$(pwd)

  if [ -f $req_file -a -s $req_file ]; then
    echo "LOG - ${req_file} file exists and is not empty within ${current_dir}. Installing dependencies."

    pkg_dir="python"

    rm -rf ${pkg_dir} && mkdir -p ${pkg_dir}
    docker run -rm -v $(pwd):/foo lambci/lambda:build-python3.8
    \
    pip install -r ${req_file} -t ${pkg_dir}

    echo "LOG - Installation complete. Zipping."

    mkdir -p dependencies

    zip -rq dependencies/lambda_layer_deps.zip ${pkg_dir}
    rm -rf ${pkg_dir}

    echo "LOG - Zipping lambda code."
    zip -rq lambda.zip lambda.py
  else
    echo "LOG - Skipping dependency packaging since ${req_file} file does not exist or is empty within ${current_dir}"
  fi
}