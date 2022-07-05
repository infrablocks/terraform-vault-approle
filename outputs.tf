output "default_secret_id" {
  value = try(vault_approle_auth_backend_role_secret_id.default[0].secret_id, "")
}
