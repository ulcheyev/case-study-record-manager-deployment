resource "keycloak_oidc_identity_provider" "google" {
  count = var.enable_google_login ? 1 : 0

  realm = keycloak_realm.realm.realm

  alias        = "google"
  display_name = "Google"

  enabled     = true
  store_token = true
  trust_email = true

  authorization_url = "https://accounts.google.com/o/oauth2/v2/auth"
  token_url         = "https://oauth2.googleapis.com/token"
  user_info_url     = "https://openidconnect.googleapis.com/v1/userinfo"
  jwks_url          = "https://www.googleapis.com/oauth2/v3/certs"

  client_id     = var.google_client_id
  client_secret = var.google_client_secret

  default_scopes = "openid profile email"
}