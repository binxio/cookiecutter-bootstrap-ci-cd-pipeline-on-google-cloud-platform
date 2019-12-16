resource "google_project" "infrastructure" {
  name            = "{{cookiecutter.project_name}}-${terraform.workspace}"
  project_id      = "{{cookiecutter.project_name}}-${terraform.workspace}"
  billing_account = "{{cookiecutter.billing_account}}"
}