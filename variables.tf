variable "key-region" {
  description = "Control Tower's KMS key region"
  type        = string
  default     = "us-east-1"
}

variable "key-alias" {
  description = "Control Tower's KMS key alias"
  type        = string
  default     = "abrigo1-control-tower"
}
