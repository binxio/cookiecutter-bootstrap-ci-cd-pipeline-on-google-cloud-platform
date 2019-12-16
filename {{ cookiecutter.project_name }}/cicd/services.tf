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

