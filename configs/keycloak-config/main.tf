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

# MediaCMS Client configuration
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

resource "keycloak_openid_client_default_scopes" "mediacms_default_scopes" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.mediacms.id

  default_scopes = [
    data.keycloak_openid_client_scope.profile.name,
    data.keycloak_openid_client_scope.email.name,
    keycloak_openid_client_scope.mediacms_roles_scope.name
  ]

}

data "keycloak_openid_client_scope" "roles" {
  realm_id = keycloak_realm.realm.id
  name     = "roles"
}

resource "keycloak_openid_client_scope" "mediacms_roles_scope" {
  realm_id = keycloak_realm.realm.id

  name        = "mediacms-roles"
  description = "Adds realm roles to tokens and userinfo for MediaCMS"
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "mediacms_realm_roles_mapper" {
  realm_id        = keycloak_realm.realm.id
  client_scope_id = keycloak_openid_client_scope.mediacms_roles_scope.id

  name                = "realm roles"
  multivalued         = true
  claim_name    = "realm_access.roles"

  add_to_access_token = true
  add_to_id_token     = false
  add_to_userinfo     = true
}


data "keycloak_openid_client_scope" "profile" {
  realm_id = keycloak_realm.realm.id
  name     = "profile"
}

data "keycloak_openid_client_scope" "email" {
  realm_id = keycloak_realm.realm.id
  name     = "email"
}

output "mediacms_client_secret" {
  value     = keycloak_openid_client.mediacms.client_secret
  sensitive = true
}