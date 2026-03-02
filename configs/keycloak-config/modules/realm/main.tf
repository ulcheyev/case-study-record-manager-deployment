terraform {
  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
    }
  }
}

resource "keycloak_realm" "realm" {
  realm                 = var.kc_realm
  access_token_lifespan = var.kc_access_token_lifespan

  ssl_required             = "external"
  registration_allowed     = false
  login_with_email_allowed = true
  duplicate_emails_allowed = false
  reset_password_allowed   = false
  edit_username_allowed    = false

  sso_session_idle_timeout     = "30m"
  sso_session_max_lifespan     = "10h"
  offline_session_idle_timeout = "720h"
}

output "realm_id" {
  value = keycloak_realm.realm.id
}