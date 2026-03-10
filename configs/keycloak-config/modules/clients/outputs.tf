output "mediacms_client_secret" {
  value     = keycloak_openid_client.mediacms.client_secret
  sensitive = true
}

output "annotator_client_secret" {
  value     = keycloak_openid_client.annotator.client_secret
  sensitive = true
}

output "mediacms_client_id" {
  value = keycloak_openid_client.mediacms.id
}

output "annotator_client_id" {
  value = keycloak_openid_client.annotator.id
}