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
  python3-venv

if ! command -v az >/dev/null 2>&1; then
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
fi

if ! command -v ansible >/dev/null 2>&1; then
  sudo add-apt-repository --yes --update ppa:ansible/ansible
  sudo apt-get install -y ansible
fi

if ! command -v terraform >/dev/null 2>&1; then
  UBUNTU_CODENAME="$(lsb_release -cs)"
  sudo rm -f /usr/share/keyrings/hashicorp-archive-keyring.gpg
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com ${UBUNTU_CODENAME} main" | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  sudo apt-get update -y || true

  # Some Ubuntu codenames are not published in HashiCorp apt yet; fallback to direct binary install.
  if ! sudo apt-get install -y terraform; then
    TF_VERSION="1.8.5"
    curl -fsSL -o /tmp/terraform.zip "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
    unzip -o /tmp/terraform.zip -d /tmp
    sudo install /tmp/terraform /usr/local/bin/terraform
    rm -f /tmp/terraform /tmp/terraform.zip
  fi
fi

if [ ! -f /home/vagrant/.ssh/id_rsa.pub ]; then
  sudo -u vagrant mkdir -p /home/vagrant/.ssh
  sudo -u vagrant ssh-keygen -t rsa -b 4096 -f /home/vagrant/.ssh/id_rsa -N ""
fi

sudo apt-get install -y jq

echo "Control node listo: Terraform, Ansible y Azure CLI instalados."
echo "Próximo paso: az login"
echo "Luego: cd /home/vagrant/parcial1cloud && bash infra/scripts/provision.sh"
