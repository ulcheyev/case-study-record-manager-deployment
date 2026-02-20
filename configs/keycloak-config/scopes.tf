data "keycloak_openid_client_scope" "profile" {
  realm_id = keycloak_realm.realm.id
  name     = "profile"
}

data "keycloak_openid_client_scope" "email" {
  realm_id = keycloak_realm.realm.id
  name     = "email"
}

resource "keycloak_openid_client_scope" "realm_roles_scope" {
  realm_id    = keycloak_realm.realm.id
  name        = "realm-roles"
  description = "Adds realm roles to access tokens"
}

resource "keycloak_openid_user_realm_role_protocol_mapper" "realm_roles_mapper" {
  realm_id        = keycloak_realm.realm.id
  client_scope_id = keycloak_openid_client_scope.realm_roles_scope.id

  name                = "realm roles"
  multivalued         = true
  claim_name          = "realm_access.roles"

  add_to_access_token = true
  add_to_id_token     = false
  add_to_userinfo     = false
}

resource "keycloak_openid_client_default_scopes" "mediacms_default_scopes" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.mediacms.id

  default_scopes = [
    data.keycloak_openid_client_scope.profile.name,
    data.keycloak_openid_client_scope.email.name,
    keycloak_openid_client_scope.realm_roles_scope.name
  ]
}

resource "keycloak_openid_client_default_scopes" "annotator_default_scopes" {
  realm_id  = keycloak_realm.realm.id
  client_id = keycloak_openid_client.annotator.id

  default_scopes = [
    data.keycloak_openid_client_scope.profile.name,
    data.keycloak_openid_client_scope.email.name,
    keycloak_openid_client_scope.realm_roles_scope.name
  ]
}
