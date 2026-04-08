#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get install -y \
  software-properties-common \
  curl \
  gnupg \
  lsb-release \
  unzip \
  python3 \
  python3-pip \
  python3-venv \
  openssh-client \
  jq

if ! command -v terraform >/dev/null 2>&1; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  sudo apt-get update -y
  sudo apt-get install -y terraform
fi

if ! command -v ansible >/dev/null 2>&1; then
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt-get install -y ansible
fi

echo "Control node local listo: Terraform y Ansible instalados."
echo "Flujo esperado:"
echo "1) En host Windows, ejecutar Terraform en host-terraform para generar Vagrantfile."
echo "2) Luego, en host Windows, ejecutar vagrant up y vagrant ssh local-control-node."