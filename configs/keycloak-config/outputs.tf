output "mediacms_client_secret" {
  value     = keycloak_openid_client.mediacms.client_secret
  sensitive = true
}

output "annotator_client_secret" {
  value     = keycloak_openid_client.annotator.client_secret
  sensitive = true
}