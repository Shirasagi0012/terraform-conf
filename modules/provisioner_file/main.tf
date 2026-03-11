resource "null_resource" "provisioner" {
  triggers = var.triggers

  connection {
    type        = "ssh"
    host        = var.ssh_host
    user        = var.ssh_user
    private_key = var.ssh_private_key
    timeout     = "5m"
  }

  provisioner "file" {
    content     = var.file_content
    destination = var.file_remote_path
  }
}
