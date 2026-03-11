locals {
  snippet_filename = "flatcar-ignition-${substr(sha256("${var.proxmox_config.target_node}:${var.vm_name}"), 0, 12)}.json"
}

data "ct_config" "flatcar_ignition" {
  content = var.butane_config
  strict  = true
}

module "upload_ignition" {
  source = "../provisioner_file"

  ssh_host         = var.proxmox_config.pve_host
  ssh_user         = var.proxmox_config.pve_user
  ssh_private_key  = var.proxmox_config.ssh_private_key
  file_content     = data.ct_config.flatcar_ignition.rendered
  file_remote_path = "/srv/ve/snippets/${local.snippet_filename}"

  triggers = {
    ignition_hash = sha256(data.ct_config.flatcar_ignition.rendered)
  }
}

resource "null_resource" "flatcar_ignition_revision" {
  triggers = {
    ignition_hash = sha256(data.ct_config.flatcar_ignition.rendered)
  }
}

resource "proxmox_vm_qemu" "this" {
  name        = var.vm_name
  target_node = var.proxmox_config.target_node
  tags        = var.tags

  clone = var.proxmox_config.flatcar_source_vmid

  cpu {
    cores   = var.cores
    sockets = var.sockets
  }

  memory = var.memory

  agent   = 1
  os_type = "cloud-init"

  network {
    id     = 0
    model  = "virtio"
    bridge = var.proxmox_config.bridge
    tag    = var.network_vlan_tag
  }

  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = var.proxmox_config.storage
  }

  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = var.proxmox_config.storage
    format  = "raw"
    size    = var.system_disk_size
  }

  startup_shutdown {
    order            = var.startup_order
    shutdown_timeout = var.shutdown_timeout
    startup_delay    = var.startup_delay
  }

  cicustom = "user=${var.proxmox_config.storage}:snippets/${local.snippet_filename}"

  lifecycle {
    replace_triggered_by = [null_resource.flatcar_ignition_revision]
  }

  depends_on = [module.upload_ignition]
}
