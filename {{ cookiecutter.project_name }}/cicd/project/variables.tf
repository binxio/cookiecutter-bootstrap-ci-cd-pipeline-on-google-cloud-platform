variable "project_name" {}
variable "billing_account" {}
variable "project_owner" {}

output "project_id" {
  value = google_project.cicd.project_id
}

output "number" {
  value = google_project.cicd.number
}
