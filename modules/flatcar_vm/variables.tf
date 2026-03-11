terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
    null = {
      source = "hashicorp/null"
    }
    ct = {
      source = "poseidon/ct"
    }
  }
}

variable "proxmox_config" {
  description = "Proxmox connection and VM defaults"
  type = object({
    pve_host            = string
    pve_user            = string
    target_node         = string
    flatcar_source_vmid = string
    storage             = string
    bridge              = string
    ssh_private_key     = string
  })
}

variable "butane_config" {
  description = "Butane YAML content provided by the caller"
  type        = string
}

variable "vm_name" {
  description = "Name of the Flatcar VM"
  type        = string
  default     = "tf-flatcar-container-host"
}

variable "tags" {
  description = "Tag string on the VM"
  type        = string
  default     = "terraform-managed"
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 4
}

variable "sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 8192
}

variable "network_vlan_tag" {
  description = "VLAN tag for network interface"
  type        = number
  default     = 20
}

variable "system_disk_size" {
  description = "Main system disk size"
  type        = string
  default     = "20G"
}

variable "startup_order" {
  description = "VM startup order"
  type        = number
  default     = 100
}

variable "shutdown_timeout" {
  description = "Shutdown timeout for startup/shutdown block"
  type        = number
  default     = -1
}

variable "startup_delay" {
  description = "Startup delay for startup/shutdown block"
  type        = number
  default     = -1
}
