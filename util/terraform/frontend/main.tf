terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"  

  backend "s3" {
    bucket = "anyhasher-terraform"
    key    = "anyhasher-fe.tfstate"
    region = "ap-south-1"
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "s3" {
  source = "./modules/s3"
  bucket_name = var.bucket_name
}

variable "bucket_name" {
  description = "Website bucket name"
}

output "website_endpoint" {
  value = module.s3.website_endpoint
}

output "bucket_name" {
  value = module.s3.bucket_name
}

