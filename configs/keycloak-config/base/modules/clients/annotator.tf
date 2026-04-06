 resource "keycloak_openid_client" "annotator" {
   realm_id = var.realm_id

   client_id   = "media-asset-annotator"
   name        = "Media Asset Annotator"
   enabled     = true
   access_type = "CONFIDENTIAL"

   standard_flow_enabled         = true
   implicit_flow_enabled         = false
   direct_access_grants_enabled  = false
   service_accounts_enabled      = false

   valid_redirect_uris = [
     "${var.public_origin}/oauth2/callback"
   ]

   valid_post_logout_redirect_uris = [
     "${var.public_origin}/*"
   ]

   web_origins = [var.public_origin]
 }