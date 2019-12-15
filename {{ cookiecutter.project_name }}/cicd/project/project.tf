#
#
# GCP project definition for CICD pipelines of an application
#
resource "google_project" "cicd" {
  name            = var.project_name
  project_id      = var.project_name
  billing_account = var.billing_account
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

resource "google_project_service" "cloudresourcemanager" {
  service = "cloudresourcemanager.googleapis.com"
  project = google_project.cicd.project_id
}

resource "google_project_service" "serviceusage" {
  service = "serviceusage.googleapis.com"
  project = google_project.cicd.project_id
}

resource "google_project_service" "pubsub" {
  service = "pubsub.googleapis.com"
  project = google_project.cicd.project_id
}

resource "google_project_service" "run" {
  service = "run.googleapis.com"
  project = google_project.cicd.project_id
}

#
# IAM policy bindings
#
resource "google_project_iam_binding" "owner" {
  role = "roles/owner"
  members = [
    "user:${var.project_owner}",
    "serviceAccount:${google_project.cicd.number}@cloudbuild.gserviceaccount.com",
  ]
  project = google_project.cicd.project_id
}

resource "google_project_iam_binding" "serviceAccountTokenCreator" {
  role = "roles/iam.serviceAccountTokenCreator"
  members = [
    "user:${var.project_owner}",
    "serviceAccount:service-${google_project.cicd.number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
  project = google_project.cicd.project_id
}
