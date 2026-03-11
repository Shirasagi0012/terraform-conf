locals {
  auto_dns_records = [
    for domain in module.pve-dormintory.caddy_config.domains : {
      name     = domain
      type     = "CNAME"
      content  = "shirasagi.space"
      settings = { flatten_cname = false }
    }
  ]
}


module "dns_records" {
  source  = "./modules/cloudflare_dns"
  zone_id = var.cloudflare_zone_id

  dns_records = concat(var.manual_dns_records, local.auto_dns_records)
}
