terraform {
  backend "gcs" {
    bucket = "{{cookiecutter.project_name}}-cicd"
    prefix = "infrastructure"
  }
}

provider google {
}
