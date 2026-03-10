variable "realm_id" {
  type = string
}

# --------------------
# Google
# --------------------

variable "enable_google" {
  type    = bool
  default = false
}

variable "google_client_id" {
  type      = string
}

variable "google_client_secret" {
  type      = string
  sensitive = true
}
