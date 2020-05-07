# Received parameters

# $1 - Release files path compared to current working directory
# $2 - name of lambda function in aws env
# $3 - lambda file name
# $3 - AWS profile to use with the aws cli
# $4 - AWS region

function deployLambda {
  set -e
  
  lambda_path=$1
  lambda_aws_name=$2
  lambda_file_name=$3
  aws_profile=$4
  aws_region=$5

  echo "LOG - Deploying Lambda ${lambda_aws_name} to AWS with profile ${aws_profile}"

  export AWS_PROFILE=${aws_profile}
  export AWS_DEFAULT_REGION=${aws_region}

  cd "${lambda_path}"

  if [ -f "${lambda_file_name}-deps.zip" ]; then
    echo "LOG - Found Lambda dependencies. Creating Lambda Layer."

    layer_version_arn=$(aws lambda publish-layer-version --layer-name "dependencies-${lambda_aws_name}" --zip-file fileb://./${lambda_file_name}-deps.zip --compatible-runtimes python3.8 | jq -r .LayerVersionArn)
    aws lambda update-function-configuration --function-name "${lambda_aws_name}" --layers ${layer_version_arn}
  fi

  echo "LOG - Updating function code."
  aws lambda update-function-code --function-name "${lambda_aws_name}" --zip-file fileb://./${lambda_file_name}.zip

}