
module "project" {
  source          = "./project"
  project_name    = "{{cookiecutter.project_name}}-${terraform.workspace}"
  project_owner   = "{{cookiecutter.project_owner}}"
  billing_account = "{{cookiecutter.billing_account}}"
}