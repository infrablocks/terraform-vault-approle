data "terraform_remote_state" "prerequisites" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../state/prerequisites.tfstate"
  }
}

module "approle" {
  # This makes absolutely no sense. I think there's a bug in terraform.
  source = "./../../../../../../../"

  component             = var.component
  deployment_identifier = var.deployment_identifier

  backend = var.backend

  role_name        = var.role_name
  role_name_prefix = var.role_name_prefix

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

  default_secret_id_cidr_list = var.default_secret_id_cidr_list
}
