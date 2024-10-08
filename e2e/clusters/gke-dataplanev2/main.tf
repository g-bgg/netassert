terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.57.0"
    }
  }
}

provider "google" {
  zone    = var.zone
}

resource "google_container_cluster" "e2etest" {
  name               = var.cluster_name
  initial_node_count = 4
  datapath_provider  = var.use_dataplanev2 ? "ADVANCED_DATAPATH" : null
  ip_allocation_policy {}
  node_config {
    machine_type = "e2-standard-2"
    disk_size_gb = 50
  }

  release_channel {
    channel = var.cluster_version
  }

  provisioner "local-exec" {
    environment = {
      KUBECONFIG = var.kubeconfig_file
    }
    command = "gcloud container clusters get-credentials ${self.name} --region ${self.location}"
  }
}



