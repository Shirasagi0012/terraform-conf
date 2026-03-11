locals {
  manual_stream_servers = local.stream_proxy

  proxy_services = [
    module.caddy
  ]

}

module "nginx_config" {
  source = "../../modules/nginx_config"

  manual_configs = local.manual_stream_servers
  services       = local.proxy_services
}

locals {
  nginx_provisioner_script = templatefile("${path.module}/templates/provision-nginx.sh.tftpl", {
    stream_config = module.nginx_config.stream_config
    nginx_package = "nginx-full"
  })
}

module "nginx" {
  source = "../../modules/service_container"

  # Container specific config
  vmid       = 400
  hostname   = "tf-reverse-proxy"
  ip_address = "192.168.40.2/24"
  gateway    = "192.168.40.1"
  vlan_tag   = 40

  # Provisioning
  provision_script = local.nginx_provisioner_script

  # Global config
  proxmox_config = local.proxmox_config
}
