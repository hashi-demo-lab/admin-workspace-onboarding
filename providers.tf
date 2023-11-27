## Place your Terraform Args / Provider version args here
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.18.0"
    }

    tfe = {
      source = "hashicorp/tfe"
      version = "0.50.0"
    }
  }
}

provider "github" {
  # Configuration options
  owner = var.github_org
}
