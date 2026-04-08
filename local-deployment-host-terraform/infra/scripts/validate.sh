#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TF_DIR="$ROOT_DIR/infra/terraform"
INVENTORY_FILE="$ROOT_DIR/infra/ansible/inventory.ini"

cd "$TF_DIR"
HAPROXY_IP="$(terraform output -raw vm_haproxy_private_ip)"
MICRO_IP="$(terraform output -raw vm_microservices_private_ip)"
HAPROXY_KEY="$ROOT_DIR/.vagrant/machines/local-haproxy/virtualbox/private_key"
MICRO_KEY="$ROOT_DIR/.vagrant/machines/local-microservices/virtualbox/private_key"

if [[ -z "${HAPROXY_IP}" || -z "${MICRO_IP}" ]]; then
  echo "No se pudieron obtener las IPs de salida de Terraform."
  exit 1
fi

if [[ ! -f "$INVENTORY_FILE" ]]; then
  echo "No existe $INVENTORY_FILE. Ejecuta primero terraform apply."
  exit 1
fi

ANSIBLE_USER="$(awk -F= '/^ansible_user=/{print $2}' "$INVENTORY_FILE" | tail -n 1)"

if [[ -z "$ANSIBLE_USER" || -z "$HAPROXY_KEY" || -z "$MICRO_KEY" ]]; then
  echo "No se pudo leer ansible_user o las llaves SSH desde inventory.ini"
  exit 1
fi

SSH_OPTS_HAPROXY=(-F /dev/null -i "$HAPROXY_KEY" -o StrictHostKeyChecking=accept-new)
SSH_OPTS_MICRO=(-F /dev/null -i "$MICRO_KEY" -o StrictHostKeyChecking=accept-new)

echo "[1/2] Verificando servicio HAProxy en ${HAPROXY_IP}..."
HAPROXY_STATUS="$(ssh "${SSH_OPTS_HAPROXY[@]}" "${ANSIBLE_USER}@${HAPROXY_IP}" "systemctl is-active haproxy" 2>/dev/null || true)"
if [[ "$HAPROXY_STATUS" != "active" ]]; then
  echo "FAIL: HAProxy no esta activo (status=${HAPROXY_STATUS:-unknown})."
  exit 1
fi
echo "PASS: HAProxy activo."

echo "[2/2] Verificando contenedores en ${MICRO_IP}..."
CONTAINERS="$(ssh "${SSH_OPTS_MICRO[@]}" "${ANSIBLE_USER}@${MICRO_IP}" "docker ps --format '{{.Names}}' | sort" 2>/dev/null || true)"

for required in users-service products-service orders-service; do
  if ! grep -qx "$required" <<< "$CONTAINERS"; then
    echo "FAIL: No se encontro el contenedor requerido: $required"
    echo "Contenedores actuales:"
    echo "$CONTAINERS"
    exit 1
  fi
done

echo "PASS: Los 3 microservicios estan activos."
echo "VALIDACION OK: el entorno local esta operativo."