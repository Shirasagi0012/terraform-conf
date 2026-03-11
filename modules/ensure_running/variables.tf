variable "pm_api_url" {
  type        = string
  description = "Proxmox API URL"
}

variable "pm_api_token_id" {
  type        = string
  description = "Proxmox API Token ID"
}

variable "pm_api_token_secret" {
  type        = string
  description = "Proxmox API Token Secret"
  sensitive   = true
}

variable "target_node" {
  type        = string
  description = "Target Proxmox Node"
}

variable "vmid" {
  type        = number
  description = "VM ID of the container"
}

variable "container_id" {
  type        = string
  description = "The ID of the container resource to trigger re-runs if it changes"
}
