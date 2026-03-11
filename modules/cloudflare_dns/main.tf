terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

resource "cloudflare_dns_record" "this" {
  for_each = { for record in var.dns_records : "${record.name}-${record.type}-${md5(record.content)}" => record }

  zone_id  = var.zone_id
  name     = each.value.name
  type     = each.value.type
  content  = each.value.content
  proxied  = each.value.proxied
  ttl      = each.value.ttl
  tags     = each.value.tags
  settings = each.value.settings
}

