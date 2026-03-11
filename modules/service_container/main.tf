resource "proxmox_lxc" "container" {
  vmid         = var.vmid
  clone        = var.proxmox_config.container_source_vmid
  full         = true
  hostname     = var.hostname
  unprivileged = true
  target_node  = var.proxmox_config.target_node
  cores        = var.cores
  memory       = var.memory
  start        = true
  tags         = "terraform-managed"
  onboot       = true

  rootfs {
    storage = var.proxmox_config.storage
    size    = var.disk_size
  }

  network {
    name   = "eth0"
    bridge = var.proxmox_config.bridge
    ip     = var.ip_address
    gw     = var.gateway
    tag    = var.vlan_tag
  }
}

module "container_ensure_running" {
  source = "../ensure_running"

  pm_api_url          = var.proxmox_config.pm_api_url
  pm_api_token_id     = var.proxmox_config.pm_api_token_id
  pm_api_token_secret = var.proxmox_config.pm_api_token_secret
  target_node         = var.proxmox_config.target_node
  vmid                = proxmox_lxc.container.vmid
  container_id        = tostring(proxmox_lxc.container.id)
}

module "container_bootstrap" {
  source = "../provisioner_script"

  depends_on = [
    module.container_ensure_running
  ]

  triggers = {
    container_id    = tostring(proxmox_lxc.container.id)
    script_checksum = md5(var.provision_script)
  }

  ssh_host           = element(split("/", proxmox_lxc.container.network[0].ip), 0)
  ssh_private_key    = var.proxmox_config.ssh_private_key
  script_content     = var.provision_script
  script_remote_path = "/tmp/provision.sh"

}
