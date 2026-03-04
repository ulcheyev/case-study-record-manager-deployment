# For RM frontend OIDC refer to https://github.com/kbss-cvut/record-manager-ui/blob/main/src/utils/OidcUtils.js
resource "keycloak_openid_client" "record_manager" {
  realm_id  = var.realm_id
  client_id = "record-manager"
  name      = "Record Manager"

  enabled     = true
  access_type = "PUBLIC"

  standard_flow_enabled         = true
  implicit_flow_enabled         = false
  direct_access_grants_enabled  = false
  service_accounts_enabled      = false

  root_url = var.public_origin
  base_url = var.public_origin

  # Frontend library (oidc-client) uses PKCE.
  pkce_code_challenge_method = "S256"

  valid_redirect_uris = [
      "${var.public_origin}/record-manager/oidc-signin-callback*",
      "${var.public_origin}/record-manager/oidc-silent-callback*"
  ]

  valid_post_logout_redirect_uris = [
      "${var.public_origin}/*"
  ]

  web_origins         = [var.public_origin]
}