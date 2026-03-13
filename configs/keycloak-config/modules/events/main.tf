terraform {
  required_providers {
    keycloak = {
      source = "keycloak/keycloak"
    }
  }
}

resource "keycloak_realm_events" "events" {
  realm_id                    = var.realm_id
  events_enabled              = var.events_enabled
  admin_events_enabled        = var.admin_events_enabled
  admin_events_details_enabled = var.admin_events_details_enabled

  events_listeners = var.events_listeners
}