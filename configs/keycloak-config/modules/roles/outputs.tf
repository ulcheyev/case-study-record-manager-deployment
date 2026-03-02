output "realm_role_ids" {
  value = {
    for name, role in keycloak_role.realm_roles :
    name => role.id
  }
}