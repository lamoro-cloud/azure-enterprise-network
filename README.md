# Proyecto 1: Azure Enterprise Landing Zone con Terraform

## 📝 Descripción
Diseño y despliegue automatizado de una arquitectura de red corporativa e infraestructura base en Microsoft Azure utilizando Infraestructura como Código (IaC) con Terraform (HCL). El entorno está desplegado de forma segura en la región de Europa del Norte (Irlanda).

## 🛠️ Recursos Creados
- **Grupo de Recursos:** `rg-portfolio-redes` (Contenedor principal en `northeurope`).
- **Red Virtual (VNet):** `vnet-portfolio-principal` con espacio de direccionamiento `10.0.0.0/16`.
- **Subred Privada (Subnet):** `sub-backend-principal` con rango `10.0.1.0/24` para el aislamiento de servidores internos.

## ⚙️ Comandos Utilizados
Para la gestión del ciclo de vida de este proyecto, he utilizado los comandos principales de la CLI de Terraform de forma incremental:
1. `terraform init` - Para la descarga y configuración limpia del proveedor de Azure.
2. `terraform plan` - Para la simulación visual de los recursos antes del despliegue.
3. `terraform apply` - Para la creación real en la nube tras resolver incidencias geográficas de disponibilidad de Azure.