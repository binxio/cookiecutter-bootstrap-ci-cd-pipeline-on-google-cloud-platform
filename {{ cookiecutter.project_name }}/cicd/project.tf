resource "google_project" "cicd" {
  name            = "{{cookiecutter.project_name}}-cicd"
  project_id      = "{{cookiecutter.project_name}}-cicd"
  billing_account = "{{cookiecutter.billing_account}}"
}

resource "google_storage_bucket" "terraform_state" {
  name = google_project.cicd.project_id
  versioning {
    enabled = true
  }
  project = google_project.cicd.project_id
}

