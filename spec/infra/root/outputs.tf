output "default_secret_id" {
  value = module.approle.default_secret_id
  sensitive = true
}
