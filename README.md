# Cookiecutter SAM Custom CloudFormation Resource Provider
Template for building a CloudFormation Custom Resource Provider using the Serverless Application Model (SAM) and Python 3.7

## prerequisites
to start to develop your custom provider, make sure you have installed:
- docker
- python3
- pipenv
- aws cli
- sam cli

## create
to create a custom provider, type:

```
sam init --location https://github.com/binxio/cookiecutter-sam-custom-resource-provider.git
```

No you are ready to start implement the functionality of your custom provider. Check out: https://github.com/binxio/cfn-resource-provider
for more details.

## development
The Makefile eases your development cycle:

| target         | description                                                                  |
|----------------|------------------------------------------------------------------------------|
|help            | shows description of all available make targets				|
|build           | the lambda deployment zip in .aws-sam/					|
|test            | runs the unit tests in ./tests						|
|deploy          | uploads the lambda deployment zip file and deploys ./template.yaml to aws	|
|bucket          | creates s3 bucket for uploading the lambda zip 				|
|invoke-local    | runs integration test of events in ./events					|
|invoke-deployed | runs system test of events in ./events					|
|show-logs       | shows logs of the deployed custom provider					|
|deploy-demo     | deploys ./cloudformation/demo-stack.yaml to AWS				|
|delete-demo     | deletes ./cloudformation/demo-stack.yaml from AWS				|
