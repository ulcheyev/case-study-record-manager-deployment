resource "keycloak_openid_client" "record_manager_dev" {
  realm_id  = var.realm_id
  client_id = "record-manager-dev"
  name      = "Record Manager Dev"

  enabled     = true
  access_type = "PUBLIC"

  standard_flow_enabled      = true
  pkce_code_challenge_method = "S256"

  valid_redirect_uris = var.dev_redirect_uris
  valid_post_logout_redirect_uris = var.dev_valid_post_logout_redirect_uris
  web_origins = var.dev_web_origins
}

resource "keycloak_openid_client" "record_manager_statistics_dev" {
  realm_id  = var.realm_id
  client_id = "record-manager-statistics-dev"
  name      = "Record Manager Stats Dev"

  enabled     = true
  access_type = "PUBLIC"

  standard_flow_enabled      = true

  valid_redirect_uris = var.dev_redirect_uris
  valid_post_logout_redirect_uris = var.dev_valid_post_logout_redirect_uris
  web_origins = var.dev_web_origins
}