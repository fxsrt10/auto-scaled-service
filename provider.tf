provider "aws" {
  shared_credentials_file = "credentials"
  region = var.AWS_REGION
}
