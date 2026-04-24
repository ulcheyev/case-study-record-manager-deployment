output "group_ids" {
  description = "Map of role group name to Keycloak group ID."
  value       = { for k, g in keycloak_group.groups : k => g.id }
}