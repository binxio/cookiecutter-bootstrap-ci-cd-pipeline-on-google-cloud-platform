
module "project" {
  source          = "./project"
  project_name    = "{{cookiecutter.project_name}}-cicd"
  project_owner   = "{{cookiecutter.project_owner}}"
  billing_account = "{{cookiecutter.billing_account}}"
}