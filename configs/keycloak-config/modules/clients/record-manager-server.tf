# RM-server acts as a resource server for the RM frontend.
resource "keycloak_openid_client" "record_manager_server" {
  realm_id  = var.realm_id
  client_id = "record-manager-server"
  name      = "Record Manager Server"

  enabled     = true
  access_type = "CONFIDENTIAL"

  # No authentication flows are required since this client does not
  # perform login or token requests. It only represents the backend
  # as a protected resource in the realm.
  standard_flow_enabled        = false
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
  service_accounts_enabled     = false

  valid_redirect_uris              = []
  valid_post_logout_redirect_uris  = []
  web_origins                      = []
}