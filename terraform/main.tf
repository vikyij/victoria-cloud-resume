terraform {
  cloud {
    organization = "viky-terraform"

    workspaces {
      name = "victoria-cloud-resume"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_dynamodb_table" "my_cloud_resume_table" {
  name     = "my-cloud-resume-view"
  hash_key = "id"

  attribute {
    name = "id"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}

resource "aws_lambda_function" "cloudresume_views_api" {
  function_name = "cloudresume-views-api"
  runtime = "python3.9"
  handler       = "lambda_function.lambda_handler"
  role          = "arn:aws:iam::886436945965:role/service-role/cloudresume-views-api-role-zujjql4x"
  filename      = "lambda_function.zip"
  environment {
    variables = {
      DYNAMODB_TABLE = "my-cloud-resume-view"
    }
  }
}

resource "aws_lambda_function_url" "cloudresume_function_url" {
  function_name      = aws_lambda_function.cloudresume_views_api.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["https://victoriaudechukwu.com"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

output "lambda_function_url" {
  value = aws_lambda_function_url.cloudresume_function_url.function_url
}

data "archive_file" "zip" {
  type = "zip"
  source_dir = "${path.module}/lambda"
  output_path = "${path.module}/packedlambda.zip"
}