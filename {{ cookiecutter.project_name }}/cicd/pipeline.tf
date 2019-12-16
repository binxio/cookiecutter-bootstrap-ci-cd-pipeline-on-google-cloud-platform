#
# CICD project pipeline
#
resource "google_sourcerepo_repository" "cicd" {
  project = google_project.cicd.project_id
  name    = "cicd"
  depends_on = [google_project_service.sourcerepo]
}

resource "google_cloudbuild_trigger" "cicd" {
  project = google_sourcerepo_repository.cicd.project
  name    = "cicd-deploy"
  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.cicd.name
  }

  filename = "cloudbuild.yaml"
}

resource "google_sourcerepo_repository_iam_policy" "cicd" {
  project     = google_sourcerepo_repository.cicd.project
  repository  = google_sourcerepo_repository.cicd.name
  policy_data = data.google_iam_policy.cicd.policy_data
}

data "google_iam_policy" "cicd" {
  binding {
    role    = "roles/source.writer"
    members = []
  }
  binding {
    role = "roles/source.admin"
    members = [
      "user:{{ cookiecutter.project_owner }}",
      "serviceAccount:${google_project.cicd.number}@cloudbuild.gserviceaccount.com",
    ]
  }
}

resource "google_sourcerepo_repository" "infrastructure" {
  project = google_project.cicd.project_id
  name    = "infrastructure"
  depends_on = [google_project_service.sourcerepo]
}

resource "google_cloudbuild_trigger" "infrastructure" {
  name = "infrastructure-deploy"

  trigger_template {
    branch_name = "(master|test|production)"
    repo_name   = google_sourcerepo_repository.infrastructure.name
  }
  filename = "cloudbuild.yaml"
  project  = google_sourcerepo_repository.infrastructure.project
}

resource "google_sourcerepo_repository_iam_policy" "infrastructure" {
  project     = google_sourcerepo_repository.infrastructure.project
  repository  = google_sourcerepo_repository.infrastructure.name
  policy_data = data.google_iam_policy.sourcerepo_infrastructure.policy_data
}

data "google_iam_policy" "sourcerepo_infrastructure" {
  binding {
    role = "roles/source.writer"
    members = [
      "serviceAccount:${google_service_account.image_reference_updater.email}"
    ]
  }

  binding {
    role = "roles/source.admin"
    members = [
      "user:{{ cookiecutter.project_owner }}",
      "serviceAccount:${google_project.cicd.number}@cloudbuild.gserviceaccount.com",
    ]
  }
}
