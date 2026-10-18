# variables.tf

variable "nombre_grupo_recursos" {
  type        = string
  description = "El nombre de nuestra caja contenedora en Azure"
  default     = "rg-portfolio-redes"
}

variable "ubicacion_azure" {
  type        = string
  description = "La región del mundo donde compramos los servidores"
  default     = "northeurope"
}
