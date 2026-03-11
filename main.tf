module "pve-dormintory" {
  source = "./platforms/pve-dormintory"

  pm_api_url                  = var.pm_api_url
  pm_api_token_id             = var.pm_api_token_id
  pm_api_token_secret         = var.pm_api_token_secret
  pve_host                    = var.pve_host
  pve_user                    = var.pve_user
  shirasagi_gaming_public_key = var.shirasagi_gaming_public_key
  ssh_priv_key                = var.ssh_priv_key
  acme_email                  = var.acme_email
  cloudflare_api_token        = var.cloudflare_api_token
}
