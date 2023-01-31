
module "workpace" {
  source = "github.com/hashicorp-demo-lab/terraform-tfe-onboarding-module"

  organization = var.organization
  workspace = var.workspace

}
