resource "keycloak_openid_client" "record_manager_server" {
  realm_id  = var.realm_id
  client_id = "record-manager-server"
  name      = "Record Manager Server"

  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  direct_access_grants_enabled = true

  valid_redirect_uris = ["/*"]
  web_origins         = ["/*"]
}