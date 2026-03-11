variable "manual_configs" {
  type = list(object({
    domain    = string
    upstreams = list(string)
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
    tls_instruction = optional(string)
  }))
}

variable "services" {
  description = "List of services with http configs"
  type        = list(any)
  default     = []
}


variable "caddy_email" {
  type = string
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
  default   = null
}
