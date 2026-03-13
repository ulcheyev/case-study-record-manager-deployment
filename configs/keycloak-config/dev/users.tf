data "keycloak_group" "admin" {
  realm_id = var.realm_id
  name     = "admin-role-group"
}

resource "keycloak_user" "test_user" {
  realm_id   = var.realm_id
  username   = var.test_user_username
  enabled    = true
  email      = "${var.test_user_username}@dev.local"
  first_name = "Test"
  last_name  = "User"

  initial_password {
    value     = var.test_user_password
    temporary = false
  }
}

resource "keycloak_user_groups" "test_user_groups" {
  realm_id  = var.realm_id
  user_id   = keycloak_user.test_user.id
  group_ids = [data.keycloak_group.admin.id]
}