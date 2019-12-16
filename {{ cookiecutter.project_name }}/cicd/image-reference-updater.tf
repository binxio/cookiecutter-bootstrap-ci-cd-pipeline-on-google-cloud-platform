
resource "google_pubsub_topic" "gcr" {
  name    = "gcr"
  project = google_project.cicd.project_id
  depends_on = [google_project_service.pubsub]
}
resource "google_service_account" "cloud_run_pubsub_invoker" {
  display_name = "Cloud Run Pub/Sub invoker"
  account_id   = "cloud-run-pubsub-invoker"
  project      = google_project.cicd.project_id
}

resource "google_service_account" "image_reference_updater" {
  display_name = "Image reference updater"
  account_id   = "image-reference-updater"
  project      = google_project.cicd.project_id
}

resource "google_cloud_run_service" "image_reference_updater" {
  name     = "image-reference-updater"
  location = "us-central1"

  template {
    spec {
      container_concurrency = 1
      service_account_name  = google_service_account.image_reference_updater.email
      containers {
        image = "gcr.io/binx-io-public/image-reference-updater:0.1.2"
        env {
          name  = "REPOSITORY_NAME"
          value = "infrastructure"
        }
        env {
          name  = "REPOSITORY_PROJECT"
          value = google_project.cicd.project_id
        }
      }
    }
  }
  project    = google_project.cicd.project_id
  provider   = google-beta
  depends_on = [google_project_service.run, google_storage_bucket_iam_binding.container_registry_viewer]
  timeouts {
    create = "10m"
  }
}

resource "google_cloud_run_service_iam_binding" "image_reference_updater_invoker" {
  members = [
    "serviceAccount:${google_service_account.cloud_run_pubsub_invoker.email}"
  ]
  role     = "roles/run.invoker"
  project  = google_project.cicd.project_id
  service  = google_cloud_run_service.image_reference_updater.name
  location = google_cloud_run_service.image_reference_updater.location
}

resource "google_pubsub_subscription" "gcr" {
  name  = "image-reference-updater"
  topic = google_pubsub_topic.gcr.id

  ack_deadline_seconds = 120
  push_config {
    push_endpoint = google_cloud_run_service.image_reference_updater.status[0].url
    oidc_token {
      service_account_email = google_service_account.cloud_run_pubsub_invoker.email
    }

  }
  project = google_project.cicd.project_id
  depends_on = [google_project_service.pubsub]
}

