# Store some constants that will be used throughout the scripts.

artifact_bucket="stefan-georgescu-deployment-artifacts"
repository_key="ci-cd-example"
deploy_property_file="deploy.properties"
lambda_base_name="ci-cd-example-lambda"
s3_address="s3://${artifact_bucket}/${repository_key}"
staging_profile="stg"
prod_profile="prod"