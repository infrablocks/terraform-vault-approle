variable "component" {
  description = "The component for which this approle exists."
  type        = string
}
variable "deployment_identifier" {
  type        = string
  description = "An identifier for this instantiation."
}

variable "backend" {
  type        = string
  description = "The path of the backend for the approle. Uses the default approle backend by default."
  default     = null
}

variable "role_name" {
  type        = string
  description = "The name of the approle. Takes precedence over the default role name generation and `role_name_prefix`."
  default     = null
}

variable "role_name_prefix" {
  type        = string
  description = "The name prefix of the approle. When provided, used to prefix the default role name generation."
  default     = null
}
