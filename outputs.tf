output "role_name" {
  value = vault_approle_auth_backend_role.role.role_name
}

output "role_id" {
  value = vault_approle_auth_backend_role.role.role_id
}

output "default_secret_id" {
  value = try(vault_approle_auth_backend_role_secret_id.default[0].secret_id, "")
}
