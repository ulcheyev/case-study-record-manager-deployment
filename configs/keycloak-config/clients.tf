resource "keycloak_openid_client" "mediacms" {
  realm_id = keycloak_realm.realm.id

  client_id   = "mediacms"
  name        = "MediaCMS"
  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false

  valid_redirect_uris = [
    "${var.mediacms_base_url}/accounts/oidc/keycloak/login/callback/"
  ]

  valid_post_logout_redirect_uris = [
    "${var.mediacms_base_url}/*"
  ]

  web_origins = [
    var.mediacms_base_url
  ]
}


resource "keycloak_openid_client" "annotator" {
  realm_id = keycloak_realm.realm.id

  client_id   = "media-asset-annotator"
  name        = "Media Asset Annotator"
  enabled     = true
  access_type = "CONFIDENTIAL"

  standard_flow_enabled        = true
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false

  valid_redirect_uris = [
    "${var.public_origin}/oauth2/callback"
  ]

  valid_post_logout_redirect_uris = [
    "${var.public_origin}/*"
  ]

  web_origins = [
    var.public_origin
  ]
}