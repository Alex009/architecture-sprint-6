variable "cloud_id" {
  description = "ID облака"
}

variable "folder_id" {
  description = "ID каталога"
}

variable "zone" {
  description = "Зона облака"
}

terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.129"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone

  service_account_key_file = file("authorized_key.json")
}

data "yandex_compute_image" "debian" {
  family = "debian-12"
}

resource "yandex_vpc_network" "minikube_network" {
  name = "minikube-network"
}

resource "yandex_vpc_subnet" "minikube_network_subnet_a" {
  name       = "minikube-network-subnet-a"
  v4_cidr_blocks = ["10.0.0.0/22"]
  zone       = var.zone
  network_id = yandex_vpc_network.minikube_network.id
}

resource "yandex_compute_disk" "minikube_vm_disk" {
  name     = "minikube-vm-disk"
  type     = "network-ssd"
  zone     = var.zone
  image_id = data.yandex_compute_image.debian.image_id
  size     = 15
}

resource "yandex_compute_instance" "minikube_vm" {
  name = "minikube-vm"
  zone = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    disk_id = yandex_compute_disk.minikube_vm_disk.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.minikube_network_subnet_a.id
    nat       = true
  }

  metadata = {
    ssh-keys = "amikhailov:${file("~/.ssh/id_rsa.pub")}"
  }
}
