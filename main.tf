resource "vault_approle_auth_backend_role" "role" {
  backend   = var.backend
  role_name = local.resolved_role_name

  bind_secret_id = var.bind_secret_id

  secret_id_bound_cidrs = var.secret_id_bound_cidrs
  secret_id_num_uses    = var.secret_id_num_uses
  secret_id_ttl         = var.secret_id_ttl

  token_ttl              = var.token_ttl
  token_max_ttl          = var.token_max_ttl
  token_period           = var.token_period
  token_bound_cidrs      = var.token_bound_cidrs
  token_explicit_max_ttl = var.token_explicit_max_ttl
  token_num_uses         = var.token_num_uses
  token_type             = var.token_type
}

# Add token policies to role
# Add default secret ID for role
resource "vault_approle_auth_backend_role_secret_id" "default" {
  role_name = vault_approle_auth_backend_role.role.role_name

  metadata = jsonencode({
    component: var.component,
    deployment_identifier: var.deployment_identifier
  })
}