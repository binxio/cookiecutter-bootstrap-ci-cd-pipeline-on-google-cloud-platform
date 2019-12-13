terraform {
  # to be removed after the bootstrap
  # backend "gcs" {
  #  bucket = "{{cookiecutter.project_name}}"
  # }
}

provider google {
}
