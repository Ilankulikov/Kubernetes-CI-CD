variable "location" {
  type    = string
  default = "eastus"
}
variable "pg_user" {
  type        = string
  description = "Postgresql database user name"
  default     = "postgres"
}
variable "pg_database" {
  type        = string
  description = "Postgresql database name"
  default     = "postgres"
}

variable "pg_password" {
  type        = string
  description = "Database password"
}

variable "cluster_name" {
  type        = string
  description = "Cluster namme"
}

variable "acr_name" {
  type        = string
  description = "Registry namme"
}

variable "rg_name" {
  type        = string
  description = "Resource group name"
}

variable "env" {
  type        = string
  description = "Environment name"
  default = "dev"
}