output "services_approle_path" {
  value = vault_auth_backend.approle.path
}
output "role_name" {
  value = module.approle.role_name
}

output "role_id" {
  value = module.approle.role_id
}

output "default_secret_id" {
  value = module.approle.default_secret_id
  sensitive = true
}
