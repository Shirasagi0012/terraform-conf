module "caddy_config" {
  source = "../../modules/caddy_config"

  caddy_email          = var.acme_email
  cloudflare_api_token = var.cloudflare_api_token
  manual_configs       = local.http_proxy
}

locals {
  caddy_provisioner_script = templatefile("${path.module}/templates/provision-caddy.sh.tftpl", {})
  caddyfile                = module.caddy_config.caddyfile
}

module "caddy" {
  source = "../../modules/service_container"

  # Container specific config
  vmid       = 401
  hostname   = "tf-https-proxy"
  ip_address = "192.168.40.3/24"
  gateway    = "192.168.40.1"
  vlan_tag   = 40

  exposed_ports = [
    { internal_port = 80, external_port = 80, protocol = "tcp" },
    { internal_port = 443, external_port = 443, protocol = "tcp" }
  ]

  # Provisioning
  provision_script = local.caddy_provisioner_script

  # Global config
  proxmox_config = local.proxmox_config
}

module "caddy_config_upload" {
  source = "../../modules/provisioner_file"

  depends_on = [module.caddy]

  triggers = {
    caddyfile_hash = md5(local.caddyfile)
  }

  ssh_host        = module.caddy.container_ip
  ssh_private_key = local.proxmox_config.ssh_private_key

  file_content     = local.caddyfile
  file_remote_path = "/etc/caddy/Caddyfile"
}

module "caddy_service_reload" {
  source = "../../modules/provisioner_script"

  depends_on = [module.caddy_config_upload]

  triggers = {
    caddyfile_hash = md5(local.caddyfile)
  }

  ssh_host        = module.caddy.container_ip
  ssh_private_key = local.proxmox_config.ssh_private_key

  script_content     = <<EOF
caddy fmt --overwrite /etc/caddy/Caddyfile
systemctl reload caddy
EOF
  script_remote_path = "/tmp/caddy_service_reload.sh"

}
