locals {
  common_tags = {
    Project   = var.project_name
    ManagedBy = "terraform"
    Scope     = "local"
  }

  haproxy_private_key_path      = abspath(var.haproxy_private_key_path)
  microservices_private_key_path = abspath(var.microservices_private_key_path)
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content = templatefile("${path.module}/templates/inventory.tpl", {
    haproxy_ip                 = var.haproxy_ip
    microservices_ip           = var.microservices_ip
    ansible_user               = var.ansible_user
    haproxy_private_key_path   = local.haproxy_private_key_path
    microservices_private_key_path = local.microservices_private_key_path
    dockerhub_user             = var.dockerhub_user
    image_tag                  = var.image_tag
  })
}