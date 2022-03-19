terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.5.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region     = "eu-central-1"
  access_key = var.access_key
  secret_key = var.secret_key
}