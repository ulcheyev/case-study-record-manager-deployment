terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.0.0"
    }
  }
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = var.kc_admin_user
  password  = var.kc_admin_password
  url       = var.kc_url
}

resource "keycloak_realm" "realm" {
  realm                 = var.kc_realm
  access_token_lifespan = var.kc_access_token_lifespan
}

variable "mediacms_base_url" {
  type = string
}

resource "keycloak_openid_client" "mediacms" {
  realm_id = keycloak_realm.realm.id

  client_id   = "mediacms"
  name        = "MediaCMS"
  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false

  valid_redirect_uris = [
    "${var.mediacms_base_url}/accounts/oidc/keycloak/login/callback/"
  ]

  valid_post_logout_redirect_uris = [
    "${var.mediacms_base_url}/*"
  ]

  web_origins = [
    var.mediacms_base_url
  ]
}

output "mediacms_client_secret" {
  value     = keycloak_openid_client.mediacms.client_secret
  sensitive = true
}