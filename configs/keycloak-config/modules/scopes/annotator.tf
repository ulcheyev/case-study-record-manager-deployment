resource "keycloak_openid_client_default_scopes" "annotator_default_scopes" {
  realm_id  = var.realm_id
  client_id = var.annotator_client_id

  default_scopes = [
    data.keycloak_openid_client_scope.profile.name,
    data.keycloak_openid_client_scope.email.name,
    keycloak_openid_client_scope.realm_roles_scope.name
  ]
}