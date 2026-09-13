terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 1.12.0"
}

provider "docker" {
  host     = "ssh://maximt@158.160.155.128:22"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

resource "random_password" "mysql_root_password" {
  length  = 16
  special = false
}

resource "random_password" "mysql_password" {
  length  = 16
  special = false
}

resource "docker_image" "mysql" {
  name = "mysql:8"
}

resource "docker_container" "mysql" {
  image = docker_image.mysql.image_id
  name  = "mysql8"

  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.mysql_password.result}",
    "MYSQL_ROOT_HOST=%",
  ]

  ports {
    ip       = "127.0.0.1"
    internal = 3306
    external = 3306
  }
}
