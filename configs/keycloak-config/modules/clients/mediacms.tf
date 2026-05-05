resource "keycloak_openid_client" "mediacms" {
  realm_id = var.realm_id

  client_id   = "mediacms"
  name        = "MediaCMS"
  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled         = true
  implicit_flow_enabled         = false
  direct_access_grants_enabled  = false
  service_accounts_enabled      = false

   root_url = var.mediacms_base_url
   base_url = var.mediacms_base_url

  valid_redirect_uris = [
    "${var.mediacms_base_url}/accounts/oidc/keycloak/login/callback*"
  ]

  valid_post_logout_redirect_uris = [
    "${var.mediacms_base_url}/*"
  ]

  web_origins = [var.mediacms_base_url]
}