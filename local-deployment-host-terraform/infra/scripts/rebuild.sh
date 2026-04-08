#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TF_DIR="$ROOT_DIR/infra/terraform"
ANSIBLE_DIR="$ROOT_DIR/infra/ansible"
IMAGE_TAG="${IMAGE_TAG:-v1.0}"
SSH_DIR="${HOME}/.ssh"
HAPROXY_KEY_SOURCE="$ROOT_DIR/.vagrant/machines/local-haproxy/virtualbox/private_key"
MICRO_KEY_SOURCE="$ROOT_DIR/.vagrant/machines/local-microservices/virtualbox/private_key"
HAPROXY_KEY_TARGET="$SSH_DIR/local-haproxy.key"
MICRO_KEY_TARGET="$SSH_DIR/local-microservices.key"

mkdir -p "$SSH_DIR"

if [[ -f "$HAPROXY_KEY_SOURCE" ]]; then
	install -m 600 "$HAPROXY_KEY_SOURCE" "$HAPROXY_KEY_TARGET"
fi

if [[ -f "$MICRO_KEY_SOURCE" ]]; then
	install -m 600 "$MICRO_KEY_SOURCE" "$MICRO_KEY_TARGET"
fi

if [[ ! -f "$HAPROXY_KEY_TARGET" || ! -f "$MICRO_KEY_TARGET" ]]; then
	echo "No se pudieron preparar las llaves SSH locales de Vagrant."
	echo "Verifica que vagrant up haya creado las VMs local-haproxy y local-microservices."
	exit 1
fi

cd "$TF_DIR"
terraform init
terraform destroy -auto-approve
terraform apply -auto-approve -var="image_tag=${IMAGE_TAG}"

cd "$ANSIBLE_DIR"
ansible-playbook -i inventory.ini site.yml

echo "Rebuild reproducible local completado: destroy + apply + configure."