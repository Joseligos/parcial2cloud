# Local Deployment (Terraform Host + Terraform/Ansible Control-Node)

Esta carpeta es una variante separada del despliegue local con flujo en 2 etapas:

1. Terraform en el host Windows genera el `Vagrantfile` con 3 VMs.
2. Terraform (dentro de `local-control-node`) genera inventario y Ansible aprovisiona `local-haproxy` y `local-microservices`.

## Estructura

- `host-terraform/`: Terraform que genera `../Vagrantfile`.
- `control-node/bootstrap-control.sh`: prepara Terraform y Ansible dentro de `local-control-node`.
- `infra/terraform/`: Terraform interno para inventario de Ansible.
- `infra/ansible/`: roles/playbooks para HAProxy y microservicios.
- `infra/scripts/`: provision, rebuild, destroy y validate para ejecutar dentro de control-node.

## Flujo de uso

### 1) En host Windows (generar Vagrantfile con Terraform)

```powershell
cd local-deployment-host-terraform\host-terraform
terraform init
terraform apply -auto-approve
```

Si quieres que Terraform tambien ejecute `vagrant up` automaticamente, usa:

```powershell
terraform apply -auto-approve -var="auto_vagrant_up=true"
```

### 2) En host Windows (levantar VMs)

```powershell
cd ..
vagrant up
vagrant ssh local-control-node
```

### 3) Dentro de local-control-node (Terraform + Ansible)

```bash
cd /home/vagrant/parcial2cloud/local-deployment-host-terraform
cp infra/terraform/terraform.tfvars.example infra/terraform/terraform.tfvars
```

Edita `infra/terraform/terraform.tfvars` y completa `dockerhub_user`. Luego ejecuta:

```bash
bash infra/scripts/provision.sh
```

## Verificacion

Dentro de `local-control-node`:

```bash
bash infra/scripts/validate.sh
```

## Destruccion

Dentro de `local-control-node` (inventario/estado Terraform interno):

```bash
bash infra/scripts/destroy.sh
```

En host Windows (eliminar VMs):

```powershell
cd local-deployment-host-terraform
vagrant destroy -f
```

Tambien puedes hacerlo via Terraform (desde `host-terraform`):

```powershell
terraform destroy -auto-approve
```

## Nota

Este flujo no altera `local-deployment/` original. Todo esta encapsulado en esta carpeta separada.