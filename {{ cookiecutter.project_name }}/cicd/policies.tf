#
# IAM policy bindings
#
resource "google_project_iam_binding" "owner" {
  role = "roles/owner"
  members = [
    "user:{{cookiecutter.project_owner}}",
    "serviceAccount:${google_project.cicd.number}@cloudbuild.gserviceaccount.com",
  ]
  project = google_project.cicd.project_id
  depends_on = [google_project_service.iam]
}

resource "google_project_iam_binding" "serviceAccountTokenCreator" {
  role = "roles/iam.serviceAccountTokenCreator"
  members = [
    "user:{{cookiecutter.project_owner}}",
    "serviceAccount:service-${google_project.cicd.number}@gcp-sa-pubsub.iam.gserviceaccount.com",
  ]
  project = google_project.cicd.project_id
  depends_on = [google_project_service.iam]
}
