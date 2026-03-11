variable "zone_id" {
  description = "The Cloudflare Zone ID"
  type        = string
}

variable "dns_records" {
  description = "List of DNS records to create"
  type = list(object({
    name     = string
    type     = string
    content  = string
    proxied  = optional(bool, false)
    ttl      = optional(number, 1)
    tags     = optional(list(string), [])
    settings = optional(map(any), {})
  }))
  default = []
}
