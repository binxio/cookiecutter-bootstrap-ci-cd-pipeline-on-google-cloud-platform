cookiecutter for a a serverless CI/CD pipeline on Google Cloud Platform
=======================================================================
template for a serverless CI/CD pipeline on Google Cloud Platform


## instruction

```
cookiecutter https://github.com/binxio/cookiecutter-bootstrap-ci-cd-pipeline-on-google-cloud-platform.git
project_name [serverless-app-cicd]: petstore-cicd
project_owner [mvanholsteijn@xebia.com]:  <your google id>
billing_account []: <your billing account>
```

## 
```
cd petstore-cicd
terraform init
terraform apply -auto-approve
```

## activate backend storage
```
sed -i ''  -e 's/#/ /' provider.tf
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

