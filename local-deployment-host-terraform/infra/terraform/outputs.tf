output "vm_haproxy_private_ip" {
  value       = var.haproxy_ip
  description = "Private IP of local-haproxy"
}

output "vm_microservices_private_ip" {
  value       = var.microservices_ip
  description = "Private IP of local-microservices"
}

output "ansible_inventory_file" {
  value       = local_file.ansible_inventory.filename
  description = "Generated Ansible inventory file"
}