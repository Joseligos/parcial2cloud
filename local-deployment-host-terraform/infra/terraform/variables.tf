variable "project_name" {
  description = "Project prefix for naming local resources"
  type        = string
  default     = "parcial2cloud-local"
}

variable "haproxy_ip" {
  description = "Static private IP for the local HAProxy VM"
  type        = string
  default     = "192.168.80.2"
}

variable "microservices_ip" {
  description = "Static private IP for the local microservices VM"
  type        = string
  default     = "192.168.80.3"
}

variable "ansible_user" {
  description = "SSH user used by Ansible for the local VMs"
  type        = string
  default     = "vagrant"
}

variable "haproxy_private_key_path" {
  description = "Path to the SSH private key used for the local HAProxy VM"
  type        = string
  default     = "/home/vagrant/.ssh/local-haproxy.key"
}

variable "microservices_private_key_path" {
  description = "Path to the SSH private key used for the local microservices VM"
  type        = string
  default     = "/home/vagrant/.ssh/local-microservices.key"
}

variable "dockerhub_user" {
  description = "Docker Hub username or organization hosting the service images"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag for all services"
  type        = string
  default     = "v1.0"
}