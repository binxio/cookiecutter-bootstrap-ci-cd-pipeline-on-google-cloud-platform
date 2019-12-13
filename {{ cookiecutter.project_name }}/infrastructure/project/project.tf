#
# infrastructure project for {{ cookiecutter.project_name }}
#
resource "google_project" "infrastructure" {
  name            = var.project_name
  project_id      = var.project_name
  billing_account = var.billing_account
}

#
# IAM policy bindings
#
resource "google_project_iam_binding" "owner" {
  role = "roles/owner"
  members = [
    "serviceAccount:${data.google_project.cicd.number}@cloudbuild.gserviceaccount.com",
  ]
  project = google_project.infrastructure.project_id
}

resource "google_project_iam_binding" "viewer" {
  role = "roles/viewer"
  members = [
    "user:${var.project_owner}"
  ]
  project = google_project.infrastructure.project_id
}

data google_project "cicd" {
  project_id = "my-serverless-app-cicd"
}