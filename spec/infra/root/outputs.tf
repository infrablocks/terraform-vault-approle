output "secret_id" {
  value = module.approle.secret_id
  sensitive = true
}
