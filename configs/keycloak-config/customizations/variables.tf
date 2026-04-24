variable "kc_admin_user" {
  type = string
}

variable "kc_admin_password" {
  type      = string
  sensitive = true
}

variable "kc_url" {
  type = string
}

variable "realm_id" {
  type = string
}