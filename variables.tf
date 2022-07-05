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

variable "bind_secret_id" {
  type        = bool
  description = "Whether or not to require secret_id to be presented when logging in using this AppRole. Defaults to true."
  default     = null
}

variable "secret_id_bound_cidrs" {
  type        = list(string)
  description = "If set, specifies blocks of IP addresses which can perform the login operation."
  default     = null
}
variable "secret_id_num_uses" {
  type        = number
  description = "The number of times any particular SecretID can be used to fetch a token from this AppRole, after which the SecretID will expire. A value of zero will allow unlimited uses."
  default     = null
}
variable "secret_id_ttl" {
  type        = number
  description = "The number of seconds after which any SecretID expires."
  default     = null
}

variable "token_ttl" {
  type        = number
  description = "The incremental lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time."
  default     = null
}
variable "token_max_ttl" {
  type        = number
  description = "The maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time."
  default     = null
}
variable "token_period" {
  type        = number
  description = "If set, indicates that the token generated using this role should never expire. The token should be renewed within the duration specified by this value. At each renewal, the token's TTL will be set to the value of this field. Specified in seconds."
  default     = null
}
variable "token_bound_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks; if set, specifies blocks of IP addresses which can authenticate successfully, and ties the resulting token to these blocks as well."
  default     = null
}

variable "token_explicit_max_ttl" {
  type        = number
  description = "If set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if token_ttl and token_max_ttl would otherwise allow a renewal."
  default     = null
}
variable "token_num_uses" {
  type        = number
  description = "The maximum number of times a generated token may be used (within its lifetime); 0 means unlimited."
  default     = null
}
variable "token_type" {
  type        = string
  description = "The type of token that should be generated. Can be service, batch, or default to use the mount's tuned default (which unless changed will be service tokens). For token store roles, there are two additional possibilities: default-service and default-batch which specify the type to return unless the client requests a different type at generation time."
  default     = null
}