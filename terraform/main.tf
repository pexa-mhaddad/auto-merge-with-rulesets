terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# Minimal resource for testing
resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket-unique-name"
}