variable "manual_configs" {
  description = "List of manually defined stream servers"
  type = list(object({
    name                  = string
    listen_port           = number
    listen_address        = optional(string)
    protocol              = optional(string)
    proxy_timeout         = optional(string)
    proxy_connect_timeout = optional(string)
    backends = list(object({
      address = string
      port    = number
      weight  = optional(number)
    }))
  }))
  default = []
}

variable "services" {
  description = "List of services with stream configs"
  type        = any
  default     = []
}
