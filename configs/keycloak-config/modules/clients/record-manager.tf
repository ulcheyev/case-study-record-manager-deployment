resource "keycloak_openid_client" "record_manager" {
  realm_id  = var.realm_id
  client_id = "record-manager"
  name      = "Record Manager"

  enabled     = true
  access_type = "PUBLIC"

  standard_flow_enabled        = true
  direct_access_grants_enabled = true

  root_url = var.public_origin
  base_url = var.public_origin

  valid_redirect_uris = ["${var.public_origin}/*"]
  web_origins         = [var.public_origin]
}