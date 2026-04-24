# For statistics frontend OIDC using keycloak-js adapter
resource "keycloak_openid_client" "record_manager_statistics" {
  realm_id  = var.realm_id
  client_id = "record-manager-statistics"
  name      = "Record Manager Statistics"

  enabled     = true
  access_type = "PUBLIC"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false

  root_url = var.public_origin
  base_url = var.public_origin

  valid_redirect_uris = [
    "${var.public_origin}${var.base_path}${var.rm_base_path}/statistics*"
  ]

  valid_post_logout_redirect_uris = [
    "${var.public_origin}/*"
  ]

  web_origins = [var.public_origin]
}
