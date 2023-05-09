provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      "abrigo:service_domain" = "lz"
      "abrigo:service"        = "control-tower"
      "abrigo:env"            = "dev"
      "abrigo:owner"          = "dan.nugent@abrigo.com"
    }
  }
}
