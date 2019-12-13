cookiecutter for a a serverless CI/CD pipeline on Google Cloud Platform
=======================================================================
template for a serverless CI/CD pipeline on Google Cloud Platform


## installation instructions

```
cookiecutter https://github.com/binxio/cookiecutter-bootstrap-ci-cd-pipeline-on-google-cloud-platform.git
project_name [serverless-app]: petstore
project_owner [<your google cloud id>]:  <your google cloud id>
billing_account [<your billing account>]: <your billing account>
```

## bootstrap the CICD project
```
cd petstore/cicd
terraform init
terraform apply -auto-approve
```

## activate backend storage
```
sed -i ''  -e 's/#//' provider.tf
terraform init
Initializing the backend...
Do you want to copy existing state to the new backend?
  Pre-existing state was found while migrating the previous "local" backend to the
  newly configured "gcs" backend. No existing state was found in the newly
  configured "gcs" backend. Do you want to copy this state to the new "gcs"
  backend? Enter "yes" to copy and "no" to start with an empty state.

  Enter a value: yes


Successfully configured the backend "gcs"! Terraform will automatically
use this backend unless the backend configuration changes.
```


## push to google cloud repository

```
git init
git add .
git commit -m 'bootstrap build'
git add remote origin https://source.developers.google.com/p/{{cookiecutter.project_name}}-cicd/r/cicd
git push --set-upstream origin master
```

## bootstrap the infrastructure project
```
cd ../infrastructure
terraform init
terraform workspace new master
terraform apply -auto-approve
```

## push to google cloud repository

```
git init
git add .
git commit -m 'bootstrap build'
git add remote origin https://source.developers.google.com/p/{{cookiecutter.project_name}}-cicd/r/infrastructure
git push --set-upstream origin master
```

# Conclusion
Done! Now you have a completely serverless and automated CI/CD pipeline

