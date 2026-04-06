# --------------------------------------------------
# Built-in scopes (lookup)
# --------------------------------------------------

data "keycloak_openid_client_scope" "profile" {
  realm_id = var.realm_id
  name     = "profile"
}

data "keycloak_openid_client_scope" "email" {
  realm_id = var.realm_id
  name     = "email"
}

# --------------------------------------------------
# Custom Realm Roles Scope
# --------------------------------------------------

resource "keycloak_openid_client_scope" "realm_roles_scope" {
  realm_id    = var.realm_id
  name        = "realm-roles"
  description = "Adds realm roles to access tokens"
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "realm_roles_mapper" {
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.realm_roles_scope.id

  name        = "realm roles"
  multivalued = true
  claim_name  = "realm_access.roles"

  add_to_access_token = true
  add_to_id_token     = true
  add_to_userinfo     = true
}