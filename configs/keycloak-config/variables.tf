variable "kc_admin_user" {
  description = "Keycloak username"
  type        = string
}

variable "kc_admin_password" {
  description = "Keycloak password"
  type        = string
  sensitive   = true
}

variable "kc_url" {
  description = "Keycloak server URL"
  type        = string
  default     = "http://localhost:8080"
}

variable "kc_realm" {
  description = "Keycloak realm name"
  type        = string
}

variable "kc_access_token_lifespan" {
  description = "Access token lifespan"
  type        = string
  default     = "5m"
}

variable "mediacms_base_url" {
  type = string
}

variable "public_origin" {
  type = string
}

variable "enable_google_login" {
  type    = bool
  default = false
}

variable "google_client_id" {
  type = string
  default = ""
}

variable "google_client_secret" {
  type      = string
  sensitive = true
  default = ""
}