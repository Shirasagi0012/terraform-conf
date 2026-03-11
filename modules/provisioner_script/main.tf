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
    content     = var.script_content
    destination = var.script_remote_path
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x ${var.script_remote_path}",
      "${var.script_remote_path}"
    ]
  }
}
