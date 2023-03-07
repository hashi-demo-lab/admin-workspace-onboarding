
locals {

  workspaceConfig = flatten([for workspace in fileset(path.module, "config/*.yaml") : yamldecode(file(workspace))])
  repositories    = ""

}

module "workpace" {
  source   = "github.com/hashicorp-demo-lab/terraform-tfe-onboarding-module"
  for_each = { for workspace in local.workspaceConfig : workspace.workspace_name => workspace }

  organization                = try(each.value.organization, "")
  project_name                = try(each.value.project_name, "")
  workspace_name              = try(each.value.workspace_name, "")
  workspace_description       = try(each.value.workspace_description, "")
  workspace_terraform_version = try(each.value.workspace_terraform_version, "")
  workspace_tags              = try(each.value.workspace_tags, [])
  variables                   = try(each.value.variables, {})
  assessments_enabled         = try(each.value.assessments_enabled, false)

  # Remote State Sharing
  remote_state           = try(each.value.remote_state, false)
  remote_state_consumers = try(each.value.remote_state_consumers, [""])

  #VCS
  vcs_repo                = try(each.value.vcs_repo, {})
  workspace_vcs_directory = try(each.value.workspace_vcs_directory, "root_directory")
  workspace_auto_apply    = try(each.value.workspace_auto_apply, false)

  #Agents
  workspace_agents = try(each.value.workspace_agents, false)
  execution_mode   = try(each.value.execution_mode, "remote")
  agent_pool_name  = try(each.value.agent_pool_name, null)

  #RBAC
  workspace_read_access_emails  = try(each.value.workspace_read_access_emails, [])
  workspace_write_access_emails = try(each.value.workspace_write_access_emails, [])
  workspace_plan_access_emails  = try(each.value.workspace_plan_access_emails, [])

}





