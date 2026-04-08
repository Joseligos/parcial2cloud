variable "common_box" {
  description = "Vagrant base box for all local VMs"
  type        = string
  default     = "bento/ubuntu-22.04"
}

variable "control_name" {
  description = "Control node VM name"
  type        = string
  default     = "local-control-node"
}

variable "haproxy_name" {
  description = "HAProxy VM name"
  type        = string
  default     = "local-haproxy"
}

variable "microservices_name" {
  description = "Microservices VM name"
  type        = string
  default     = "local-microservices"
}

variable "control_ip" {
  description = "Private IP for control node"
  type        = string
  default     = "192.168.80.10"
}

variable "haproxy_ip" {
  description = "Private IP for HAProxy VM"
  type        = string
  default     = "192.168.80.2"
}

variable "microservices_ip" {
  description = "Private IP for microservices VM"
  type        = string
  default     = "192.168.80.3"
}

variable "control_memory" {
  description = "RAM (MB) for control node"
  type        = number
  default     = 1024
}

variable "control_cpus" {
  description = "vCPUs for control node"
  type        = number
  default     = 2
}

variable "haproxy_memory" {
  description = "RAM (MB) for HAProxy VM"
  type        = number
  default     = 1024
}

variable "haproxy_cpus" {
  description = "vCPUs for HAProxy VM"
  type        = number
  default     = 2
}

variable "microservices_memory" {
  description = "RAM (MB) for microservices VM"
  type        = number
  default     = 2048
}

variable "microservices_cpus" {
  description = "vCPUs for microservices VM"
  type        = number
  default     = 2
}

variable "project_mount_path" {
  description = "Absolute mount path in guest for repo root"
  type        = string
  default     = "/home/vagrant/parcial2cloud"
}

variable "deployment_mount_path" {
  description = "Absolute mount path in guest for this deployment folder"
  type        = string
  default     = "/home/vagrant/parcial2cloud/local-deployment-host-terraform"
}

variable "auto_vagrant_up" {
  description = "If true, runs 'vagrant up' automatically after generating Vagrantfile"
  type        = bool
  default     = false
}
