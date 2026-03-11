output "container_ip" {
  description = "The IP address of the container (without CIDR)"
  value       = split("/", var.ip_address)[0]
}

output "stream_configs" {
  description = "Configuration for Nginx stream proxy derived from exposed ports"
  value = [
    for p in var.exposed_ports : {
      listen_port  = coalesce(p.external_port, p.internal_port)
      backend_port = p.internal_port
      protocol     = p.protocol
      ip           = split("/", var.ip_address)[0]
    }
  ]
}

output "http_configs" {
  description = "Configuration for Caddy HTTP proxy"
  value = [
    for c in var.http_configs : {
      domain          = c.domain
      upstreams       = ["${c.protocol}://${split("/", var.ip_address)[0]}:${c.internal_port}"]
      tls_instruction = c.tls_instruction
      streaming       = c.streaming
      transport       = c.transport
    }
  ]
}
