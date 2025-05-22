terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.98.0"
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