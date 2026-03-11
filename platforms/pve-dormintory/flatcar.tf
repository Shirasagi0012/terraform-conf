module "flatcar_docker_base" {
  source = "../../modules/flatcar_vm"

  proxmox_config = local.proxmox_config
  butane_config = templatefile("${path.module}/containers/provision-flatcar.yml.tftpl", {
    path           = "${path.module}/containers"
    ssh_public_key = var.shirasagi_gaming_public_key
  })
  vm_name = "tf-flatcar-container-host"
}
