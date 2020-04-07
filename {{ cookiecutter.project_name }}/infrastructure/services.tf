# required services for the infrastructure
resource "google_project_service" "storage-component" {
  service = "storage-component.googleapis.com"
  project = google_project.infrastructure.project_id
}

resource "google_project_service" "storage-api" {
  service = "storage-api.googleapis.com"
  project = google_project.infrastructure.project_id
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  project = google_project.infrastructure.project_id
}

resource "google_project_service" "iam" {
  service = "iam.googleapis.com"
  project = google_project.infrastructure.project_id
}

resource "google_project_service" "cloudkms" {
  service = "cloudkms.googleapis.com"
  project = google_project.infrastructure.project_id
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
  project = google_project.infrastructure.project_id
}

resource "google_project_service" "pubsub" {
  service = "pubsub.googleapis.com"
  project = google_project.infrastructure.project_id
}

resource "google_project_service" "run" {
  service = "run.googleapis.com"
  project = google_project.infrastructure.project_id
}
