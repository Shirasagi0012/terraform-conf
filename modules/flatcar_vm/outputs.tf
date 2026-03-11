output "vm_id" {
  description = "Proxmox VM ID"
  value       = proxmox_vm_qemu.this.vmid
}

output "vm_name" {
  description = "VM name"
  value       = proxmox_vm_qemu.this.name
}
