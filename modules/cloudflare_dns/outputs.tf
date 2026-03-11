output "dns_records" {
  description = "The created DNS records"
  value       = cloudflare_dns_record.this
}
