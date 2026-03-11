terraform {
  required_version = ">= 1.13.0"

  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.14.0"
    }
  }
}
