terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

variable "vmid" {
  description = "The ID of the LXC container"
  type        = number
}

variable "hostname" {
  description = "The hostname of the LXC container"
  type        = string
}

variable "ip_address" {
  description = "The IP address of the container (CIDR format, e.g. 192.168.40.2/24)"
  type        = string
}

variable "gateway" {
  description = "The gateway IP address"
  type        = string
  default     = "192.168.40.1"
}

variable "vlan_tag" {
  description = "The VLAN tag for the network interface"
  type        = number
  default     = 40
}

variable "cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "memory" {
  description = "Memory size in MB"
  type        = number
  default     = 512
}

variable "disk_size" {
  description = "Rootfs disk size"
  type        = string
  default     = "20G"
}

variable "provision_script" {
  description = "Content of the provisioning script to run"
  type        = string
}

variable "exposed_ports" {
  description = "List of ports to expose via Nginx stream proxy"
  type = list(object({
    internal_port = number
    external_port = optional(number)
    protocol      = optional(string, "tcp")
  }))
  default = []
}

variable "http_configs" {
  description = "List of HTTP proxy configurations"
  type = list(object({
    domain          = string
    internal_port   = number
    protocol        = optional(string, "http")
    tls_instruction = optional(string)
    streaming = optional(object({
      flush_interval     = optional(string)
      stream_timeout     = optional(string)
      stream_close_delay = optional(string)
    }))
    transport = optional(object({
      tls_insecure_skip_verify = optional(bool)
      dial_timeout             = optional(string)
      keepalive                = optional(string)
    }))
  }))
  default = []
}

variable "proxmox_config" {
  description = "Proxmox connection and container defaults"
  type = object({
    pm_api_url            = string
    pm_api_token_id       = string
    pm_api_token_secret   = string
    pve_host              = string
    target_node           = string
    container_source_vmid = string
    flatcar_source_vmid   = string
    storage               = string
    bridge                = string
    ssh_private_key       = string
  })
}
