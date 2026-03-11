variable "pm_api_url" {
  description = "Proxmox API URL, e.g. https://proxmox.example:8006/api2/json"
  type        = string
}

variable "pm_api_token_id" {
  description = "API token id (user@realm!tokenname). Leave empty to use username/password."
  type        = string
  default     = ""
  sensitive   = true
}

variable "pm_api_token_secret" {
  description = "API token secret for the token ID above."
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssh_priv_key" {
  description = "The path of your ssh priv key"
  type        = string
  sensitive   = true
  nullable    = false
  ephemeral   = false
  default     = "~/.ssh/id_ed25519"
}

variable "pve_host" {
  description = "IP address of the Proxmox VE host"
  type        = string
}

variable "pve_user" {
  description = "User of the Proxmox VE host"
  type        = string
}

variable "shirasagi_gaming_public_key" {
  description = "SSH public key injected into the Flatcar core user"
  type        = string
}

variable "acme_email" {
  type      = string
  sensitive = true
  default   = "true"
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
  default   = null
}
