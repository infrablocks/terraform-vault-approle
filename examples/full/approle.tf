module "approle" {
  source = "./../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  backend = vault_auth_backend.approle.path

  role_name_prefix = "service"

  bind_secret_id = true

  secret_id_bound_cidrs = ["10.1.0.0/16", "10.2.0.0/16"]
  secret_id_num_uses    = 10
  secret_id_ttl         = 300

  token_ttl              = 300
  token_max_ttl          = 600
  token_period           = 300
  token_policies         = ["some", "policies"]
  token_bound_cidrs      = ["10.1.0.0/16", "10.2.0.0/16"]
  token_explicit_max_ttl = 900
  token_num_uses         = 10
  token_type             = "default"

  default_secret_id_cidr_list = ["10.1.0.0/16", "10.2.0.0/16"]
}
