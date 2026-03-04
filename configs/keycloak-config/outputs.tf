output "mediacms_client_secret" {
  value     = module.clients.mediacms_client_secret
  sensitive = true
}

output "annotator_client_secret" {
  value     = module.clients.annotator_client_secret
  sensitive = true
}