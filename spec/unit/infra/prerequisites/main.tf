resource "vault_auth_backend" "default_approle" {
  type = "approle"
}

resource "vault_auth_backend" "services_approle" {
  type = "approle"
  path = "services"
}
