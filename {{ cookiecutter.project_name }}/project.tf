#
#
# GCP project definition for CICD pipelines of an application
#
resource "google_project" "cicd" {
  name            = "{{ cookiecutter.project_name }}"
  project_id      = "{{ cookiecutter.project_name }}"
  billing_account = "{{ cookiecutter.billing_account }}"
}

resource "google_storage_bucket" "terraform_state" {
  name = google_project.cicd.project_id
  versioning {
    enabled = true
  }
  project = google_project.cicd.project_id
}

#
# services required by this project
#
resource "google_project_service" "cloudbuild" {
  service = "cloudbuild.googleapis.com"
  project = google_project.cicd.project_id
}

resource "google_project_service" "sourcerepo" {
  service = "sourcerepo.googleapis.com"
  project = google_project.cicd.project_id
}

resource "google_project_service" "containerregistry" {
  service = "containerregistry.googleapis.com"
  project = google_project.cicd.project_id
}

#
# The entire IAM policy of the CICD project is managed by terraform
#
resource "google_project_iam_binding" "owner" {
  role = "roles/owner"
  members = [
    "user:{{cookiecutter.project_owner}}",
    "serviceAccount:${google_project.cicd.number}@cloudbuild.gserviceaccount.com",
  ]
}
