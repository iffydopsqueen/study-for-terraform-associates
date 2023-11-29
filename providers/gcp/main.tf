terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.7.0"
    }
  }
}

provider "google" {
  # Configuration options
  credentials = "KEY_DERIVED_FROM_PROJECT"
  project = "PROJECT_ID_OF_THE_PROJECT"
  region = "us-west1"
  zone = "us-west1-a"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "default"
    access_config { }
  }
}