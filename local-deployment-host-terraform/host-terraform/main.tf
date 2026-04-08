locals {
  generated_vagrantfile = templatefile("${path.module}/templates/Vagrantfile.tpl", {
    common_box            = var.common_box
    control_name          = var.control_name
    haproxy_name          = var.haproxy_name
    microservices_name    = var.microservices_name
    control_ip            = var.control_ip
    haproxy_ip            = var.haproxy_ip
    microservices_ip      = var.microservices_ip
    control_memory        = var.control_memory
    control_cpus          = var.control_cpus
    haproxy_memory        = var.haproxy_memory
    haproxy_cpus          = var.haproxy_cpus
    microservices_memory  = var.microservices_memory
    microservices_cpus    = var.microservices_cpus
    project_mount_path    = var.project_mount_path
    deployment_mount_path = var.deployment_mount_path
  })
}

resource "local_file" "generated_vagrantfile" {
  filename        = "${path.module}/../Vagrantfile"
  content         = local.generated_vagrantfile
  file_permission = "0644"

  provisioner "local-exec" {
    when        = destroy
    working_dir = "${path.module}/.."
    command     = "vagrant destroy -f"
  }
}

resource "terraform_data" "vagrant_up" {
  count = var.auto_vagrant_up ? 1 : 0

  triggers_replace = [
    sha256(local.generated_vagrantfile),
  ]

  provisioner "local-exec" {
    working_dir = "${path.module}/.."
    command     = "vagrant up"
  }

  depends_on = [local_file.generated_vagrantfile]
}

output "generated_file" {
  description = "Path of the generated Vagrantfile"
  value       = local_file.generated_vagrantfile.filename
}
