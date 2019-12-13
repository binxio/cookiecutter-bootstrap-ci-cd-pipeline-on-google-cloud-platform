#
# CICD project pipeline
#
resource "google_sourcerepo_repository" "infrastructure" {
  project    = google_project.cicd.project_id
  name       = "cicd"
  depends_on = [google_project_service.sourcerepo]
}

resource "google_cloudbuild_trigger" "infrastructure" {
  project = google_sourcerepo_repository.infrastructure.project

  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.infrastructure.name
  }

  filename = "cloudbuild.yaml"
  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_sourcerepo_repository_iam_policy" "image" {
  project     = google_sourcerepo_repository.infrastructure.project
  repository  = google_sourcerepo_repository.infrastructure.name
  policy_data = data.google_iam_policy.sourcerepo_infrastructure.policy_data
}

data "google_iam_policy" "sourcerepo_infrastructure" {
  binding {
    role = "roles/source.writer"
    members = [
      "user:{{ cookiecutter.project_owner }}"
    ]
  }
  binding {
    role = "roles/source.admin"
    members = [
      "serviceAccount:${google_project.cicd.number}@cloudbuild.gserviceaccount.com",
    ]
  }
}

resource "google_sourcerepo_repository" "infrastructure" {
  project    = google_project.cicd.project_id
  name       = "infrastructure"
  depends_on = [google_project_service.sourcerepo]
}

resource "google_cloudbuild_trigger" "infrastructure" {
  project = google_sourcerepo_repository.infrastructure.project

  trigger_template {
    branch_name = "master"
    repo_name   = google_sourcerepo_repository.infrastructure.name
  }

  filename = "cloudbuild.yaml"
  depends_on = [
    google_project_service.cloudbuild
  ]
}

resource "google_sourcerepo_repository_iam_policy" "image" {
  project     = google_sourcerepo_repository.infrastructure.project
  repository  = google_sourcerepo_repository.infrastructure.name
  policy_data = data.google_iam_policy.sourcerepo_infrastructure.policy_data
}

data "google_iam_policy" "sourcerepo_infrastructure" {
  binding {
    role = "roles/source.writer"
    members = [
      "user:{{ cookiecutter.project_owner }}"
    ]
  }
  binding {
    role = "roles/source.admin"
    members = [
      "serviceAccount:${google_project.cicd.number}@cloudbuild.gserviceaccount.com",
    ]
  }
}
