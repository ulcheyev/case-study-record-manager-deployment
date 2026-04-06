variable "realm_id" {
  description = "Keycloak realm ID"
  type        = string
}

variable "events_enabled" {
  description = "Enable user events"
  type        = bool
  default     = false
}

variable "admin_events_enabled" {
  description = "Enable admin events"
  type        = bool
  default     = false
}

variable "admin_events_details_enabled" {
  description = "Enable detailed admin events"
  type        = bool
  default     = false
}

variable "events_listeners" {
  description = "List of event listeners"
  type        = list(string)
  default = [
    "jboss-logging",
    "keycloak-graphdb-user-replicator"
  ]
}