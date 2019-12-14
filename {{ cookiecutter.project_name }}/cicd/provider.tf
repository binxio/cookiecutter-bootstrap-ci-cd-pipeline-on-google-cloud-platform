terraform {
  #backend "gcs" {
  #  bucket = "{{cookiecutter.project_name}}-cicd"
  #  prefix = "cicd"
  #}
}

provider google {
}

provider google-beta {
}
