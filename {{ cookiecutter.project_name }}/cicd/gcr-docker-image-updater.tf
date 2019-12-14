
resource "google_pubsub_topic" "gcr" {
  name    = "projects/${module.project.project_id}/topics/gcr"
  project = module.project.project_id

}
resource "google_service_account" "cloud_run_pubsub_invoker" {
  display_name = "Cloud Run Pub/Sub invoker"
  account_id   = "cloud-run-pubsub-invoker"
  project      = module.project.project_id
}

resource "google_service_account" "docker_image_updater" {
  display_name = "GCR docker image updater"
  account_id   = "gcr-docker-image-updater"
  project      = module.project.project_id
}

resource "google_cloud_run_service" "docker_image_updater" {
  name     = "gcr-docker-image-updater"
  location = "us-central1"

  template {
    spec {
      container_concurrency = 1
      service_account_name  = google_service_account.docker_image_updater.email
      containers {
        image = "docker.io/binxio/gcr-docker-image-updater:0.0.0"
        env {
            name  = "REPOSITORY_NAME"
            value = "infrastructure"
        }
        env {
            name  = "REPOSITORY_PROJECT"
            value = module.project.project_id
        }
      }
    }
  }
  project  = module.project.project_id
  provider = google-beta
}

resource "google_cloud_run_service_iam_binding" "docker_image_updater_invoker" {
  members = [
    "serviceAccount:${google_service_account.cloud_run_pubsub_invoker.email}"
  ]
  role    = "roles/run.invoker"
  project = module.project.project_id
  service = google_cloud_run_service.docker_image_updater.name
}

resource "google_pubsub_subscription" "gcr" {
  name  = "docker-image-updater"
  topic = google_pubsub_topic.gcr.name
  push_config {
    push_endpoint = google_cloud_run_service.docker_image_updater.status[0].url
    oidc_token {
      service_account_email = google_service_account.cloud_run_pubsub_invoker.email
    }
  }
  project = module.project.project_id
}