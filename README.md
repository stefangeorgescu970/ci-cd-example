
# CI/CD Example Repository
This repository contains example code for implementing a CI/CD pipeline for deploying code in multiple AWS environments (accounts). The supporting infrastructure is defined using Terraform and can be found in [this repository](https://github.com/stefangeorgescu970/aws-infrastructure).

All the code presented here has been implemented as support for a Medium article with the title [**CI/CD Pipeline for AWS with Travis**](https://medium.com/@stefan.georgescu.970/ci-cd-pipeline-for-aws-with-travis-19c9448be17d). In order to fully understand the design and implementaton, it is recommended that the article is reviewed.

# Repository Structure
At the root level of the repository you can find the `.travis.yml` file containing the configuration for [Travis CI](https://docs.travis-ci.com).

### buildScripts
The `buildScripts` subdirectory contains all the shell scripts required to perform the testing, building and deployment of the code.

### src
The `src` subdirectory contains a small python file with an example Lambda Function, and a text file containing the required libraries for that lambda function to run. I have chosen to write some code that requires an external library to add some complexity to the build and deployment process.

### tests
The `tests` subdirectory contains all Test Cases for the code implemented in `src`. Given the fact that this repository is an example, I have only implemented a mock test class.

# Comments
If you have any questions regarding this implementation or the article linked above, do not hesitate to [contact me](mailto:contact@stefangeorgescu.com).