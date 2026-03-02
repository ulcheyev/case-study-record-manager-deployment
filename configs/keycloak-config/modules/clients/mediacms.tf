resource "keycloak_openid_client" "mediacms" {
  realm_id = var.realm_id

  client_id   = "mediacms"
  name        = "MediaCMS"
  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled = true

  valid_redirect_uris = [
    "${var.mediacms_base_url}/accounts/oidc/keycloak/login/callback/"
  ]

  valid_post_logout_redirect_uris = [
    "${var.mediacms_base_url}/*"
  ]

  web_origins = [var.mediacms_base_url]
}