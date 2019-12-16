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
    "user:{{cookiecutter.project_owner}}"
  ]
  project = google_project.infrastructure.project_id
}

data google_project "cicd" {
  project_id = "my-serverless-app-cicd"
}