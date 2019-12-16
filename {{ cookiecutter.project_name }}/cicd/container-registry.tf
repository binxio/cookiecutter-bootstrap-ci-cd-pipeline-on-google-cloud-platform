# required to create the Docker Container Registry bucket
resource null_resource "initialize_container_registry_bucket" {
  provisioner "local-exec" {
    command = "docker pull alpine:latest; docker tag alpine:latest gcr.io/${google_project.cicd.project_id}/alpine:latest; docker push gcr.io/${google_project.cicd.project_id}/alpine:latest"
  }
  depends_on = [google_project_service.containerregistry]
}

resource "google_storage_bucket_iam_binding" "container_registry_viewer" {
  bucket = "artifacts.${google_project.cicd.project_id}.appspot.com"
  role   = "roles/storage.objectViewer"

  members = [
    "serviceAccount:service-${google_project.cicd.number}@serverless-robot-prod.iam.gserviceaccount.com"
  ]
  depends_on = [null_resource.initialize_container_registry_bucket]
}