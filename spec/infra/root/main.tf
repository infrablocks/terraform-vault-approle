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

  role_name = var.role_name
  role_name_prefix = var.role_name_prefix
}
