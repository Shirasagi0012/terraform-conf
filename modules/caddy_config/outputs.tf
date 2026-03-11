output "caddyfile" {
  description = "Generated Caddyfile configuration content"
  value       = local.caddyfile
}

output "domains" {
  description = "List of domains configured in Caddy"
  value       = [for site in local.caddy_proxy : site.domain]
}
