variable "realm_id" {
  description = "Keycloak realm ID"
  type        = string
}

variable "realm_role_ids" {
  type = map(string)
}