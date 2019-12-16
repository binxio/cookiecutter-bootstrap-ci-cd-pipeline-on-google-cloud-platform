
resource "google_pubsub_topic" "gcr" {
  name    = "gcr"
  project = module.project.project_id

}
resource "google_service_account" "cloud_run_pubsub_invoker" {
  display_name = "Cloud Run Pub/Sub invoker"
  account_id   = "cloud-run-pubsub-invoker"
  project      = module.project.project_id
}

resource "google_service_account" "docker_image_updater" {
  display_name = "GCR docker image updater"
  account_id   = "container-image-reference-updater"
  project      = module.project.project_id
}

resource "google_cloud_run_service" "docker_image_updater" {
  name     = "container-image-reference-updater"
  location = "us-central1"

  template {
    spec {
      container_concurrency = 1
      service_account_name  = google_service_account.docker_image_updater.email
      containers {
        image = "binxio/container-image-reference-updater:0.1.0"
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
  project    = module.project.project_id
  provider   = google-beta
  depends_on = [google_storage_bucket_iam_binding.container_registry_viewer]
}

resource "google_cloud_run_service_iam_binding" "docker_image_updater_invoker" {
  members = [
    "serviceAccount:${google_service_account.cloud_run_pubsub_invoker.email}"
  ]
  role     = "roles/run.invoker"
  project  = module.project.project_id
  service  = google_cloud_run_service.docker_image_updater.name
  location = google_cloud_run_service.docker_image_updater.location
}

resource "google_pubsub_subscription" "gcr" {
  name  = "docker-image-updater"
  topic = google_pubsub_topic.gcr.id

  ack_deadline_seconds = 120
  push_config {
    push_endpoint = google_cloud_run_service.docker_image_updater.status[0].url
    oidc_token {
      service_account_email = google_service_account.cloud_run_pubsub_invoker.email
    }

  }
  project = module.project.project_id
}

# required to create the Docker Container Registry bucket
resource null_resource "initialize_container_registry_bucket" {
  provisioner "local-exec" {
    command = "docker pull alpine:latest; docker tag alpine:latest gcr.io/${module.project.project_id}/alpine:latest; docker push gcr.io/${module.project.project_id}/alpine:latest"
  }
}

resource "google_storage_bucket_iam_binding" "container_registry_viewer" {
  bucket = "artifacts.${module.project.project_id}.appspot.com"
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:service-${module.project.number}@serverless-robot-prod.iam.gserviceaccount.com"
  ]
  depends_on = [null_resource.initialize_container_registry_bucket]
}
