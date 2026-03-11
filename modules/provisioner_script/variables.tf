variable "ssh_host" {
  description = "The SSH host IP address"
  type        = string
}

variable "ssh_user" {
  description = "The SSH user"
  type        = string
  default     = "root"
}

variable "ssh_private_key" {
  description = "The content of the SSH private key"
  type        = string
  sensitive   = true
}

variable "script_content" {
  description = "The content of the script to execute"
  type        = string
}

variable "script_remote_path" {
  description = "The remote path where the script will be uploaded"
  type        = string
  default     = "/tmp/provision.sh"
}

variable "triggers" {
  description = "Map of values that trigger a re-run when changed"
  type        = map(string)
  default     = {}
}
