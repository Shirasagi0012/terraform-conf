data "ct_config" "flatcar_ignition" {
  content = templatefile("${path.module}/templates/provision-flatcar.yml.tftpl", {
    path           = "${path.module}/containers"
    ssh_public_key = var.shirasagi_gaming_public_key
  })
  strict = true
}

resource "local_file" "ignition_json" {
  content  = data.ct_config.flatcar_ignition.rendered
  filename = "${path.module}/.generated/flatcar-ignition.json"
}

module "upload_ignition" {
  source = "../../modules/provisioner_file"

  ssh_host         = local.proxmox_config.pve_host
  ssh_user         = local.proxmox_config.pve_user
  ssh_private_key  = local.proxmox_config.ssh_private_key
  file_content     = data.ct_config.flatcar_ignition.rendered
  file_remote_path = "/srv/ve/snippets/flatcar-ignition.json"

  triggers = {
    ignition_hash = sha256(data.ct_config.flatcar_ignition.rendered)
  }

  depends_on = [local_file.ignition_json]
}

resource "null_resource" "flatcar_ignition_revision" {
  triggers = {
    ignition_hash = sha256(data.ct_config.flatcar_ignition.rendered)
  }
}

resource "proxmox_vm_qemu" "flatcar_docker_base" {
  name        = "tf-flatcar-container-host"
  target_node = local.proxmox_config.target_node
  tags        = "terraform-managed"

  clone = "flatcar-template"
  cpu {
    cores   = 4
    sockets = 1
  }

  memory = 8192

  agent   = 1
  os_type = "cloud-init"

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag    = 20
  }

  # Inject Ignition JSON using CloudInit drive
  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = local.proxmox_config.storage
  }

  # Main system drive
  disk {
    slot    = "scsi0"
    type    = "disk"
    storage = local.proxmox_config.storage
    format  = "raw"
    size    = "20G"
  }

  startup_shutdown {
    order            = 100
    shutdown_timeout = -1
    startup_delay    = -1
  }

  cicustom = "user=local-srv:snippets/flatcar-ignition.json"

  lifecycle {
    replace_triggered_by = [null_resource.flatcar_ignition_revision]
  }

  depends_on = [
    module.upload_ignition
  ]
}
