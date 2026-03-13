variable "dev_redirect_uris" {
  type    = list(string)
}

variable "dev_valid_post_logout_redirect_uris" {
  type    = list(string)
}

variable "dev_web_origins" {
  type    = list(string)
}

variable "test_user_username" {
  type    = string
  default = "test"
}

variable "test_user_password" {
  type      = string
  sensitive = true
  default   = "test"
}

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