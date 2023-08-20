provider "aws" {
  region = "us-west-2" # Change this to your desired AWS region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket         = "s4-bucket-terraform"
    key            = "weather-app"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "s4-bucket-terraform"
  }
}
