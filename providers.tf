provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      "product"     = "lz"
      "application" = "control-tower"
      "environment" = "DEV"
      "owner"       = "dan.nugent@abrigo.com"
    }
  }
}
