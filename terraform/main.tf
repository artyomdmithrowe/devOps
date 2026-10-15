terraform {
  required_version = ">= 1.1.5"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
  }
}

variable "server_ip" {
  description = "IP address of the remote Docker host"
  type        = string
}

provider "docker" {
  host = "ssh://deployer@${var.server_ip}:22"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_network" "nginx_network" {
  name = "nginx_network"
}

resource "docker_volume" "nginx_volume" {
  name = "nginx_volume"
}

resource "docker_container" "nginx_container" {
  name  = "nginx_container"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.nginx_network.name
  }

  volumes {
    volume_name    = docker_volume.nginx_volume.name
    container_path = "/usr/share/nginx/html"
  }

  ports {
    internal = 80
    external = 8081
  }
}
