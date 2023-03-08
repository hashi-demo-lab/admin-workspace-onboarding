
locals {
  workspaceConfig = flatten([for workspace in fileset(path.module, "config/*.yaml") : yamldecode(file(workspace))])
  workspaces      = { for workspace in local.workspaceConfig : workspace.workspace_name => workspace }
  workspaceRepos  = { for workspace in local.workspaceConfig : workspace.workspace_name => workspace if workspace.create_repo }
}

module "github" {
  ## TO DO - need to tag module and pin version
  source   = "github.com/hashicorp-demo-lab/terraform-github-repository-module"
  for_each = local.workspaceRepos

  github_org                       = try(each.value.github.github_org, "hashicorp-demo-lab")
  github_org_owner                 = try(each.value.github.github_org_owner, "hashicorp-demo-lab")
  github_repo_name                 = try(each.value.github.github_repo_name, "test")
  github_repo_desc                 = try(each.value.github.github_repo_desc, "")
  github_repo_visibility           = try(each.value.github.github_repo_visibility, "public")
  github_team_name                 = try(each.value.github.github.github_team_name, "demo-team")
  github_template_owner            = try(each.value.github.github_template_owner, "hashicorp-demo-lab")
  github_repo_permission           = try(each.value.github.github_repo_permission, "admin")
  github_template_repo             = try(each.value.github.github_template_repo, "terraform-template")
  github_template_include_branches = try(each.value.github.github_template_include_branches, false)
}

module "workspace" {
  ## TO DO - need to tag module and pin version
  source = "github.com/hashicorp-demo-lab/terraform-tfe-onboarding-module"

  depends_on = [
    module.github
  ]

  for_each = local.workspaces

  organization                = try(each.value.organization, "")
  create_project              = try(each.value.create_project, false)
  project_name                = try(each.value.project_name, "")
  workspace_name              = try(each.value.workspace_name, "")
  workspace_description       = try(each.value.workspace_description, "")
  workspace_terraform_version = try(each.value.workspace_terraform_version, "")
  workspace_tags              = try(each.value.workspace_tags, [])
  variables                   = try(each.value.variables, {})
  assessments_enabled         = try(each.value.assessments_enabled, false)

  file_triggers_enabled   = try(each.value.file_triggers_enabled, true)
  workspace_vcs_directory = try(each.value.workspace_vcs_directory, "root_directory")
  workspace_auto_apply    = try(each.value.workspace_auto_apply, false)

  # Remote State Sharing
  remote_state           = try(each.value.remote_state, false)
  remote_state_consumers = try(each.value.remote_state_consumers, [""])

  #VCS block
  vcs_repo = try(each.value.vcs_repo, {})

  #Agents
  workspace_agents = try(each.value.workspace_agents, false)
  execution_mode   = try(each.value.execution_mode, "remote")
  agent_pool_name  = try(each.value.agent_pool_name, null)

  #RBAC
  workspace_read_access_emails  = try(each.value.workspace_read_access_emails, [])
  workspace_write_access_emails = try(each.value.workspace_write_access_emails, [])
  workspace_plan_access_emails  = try(each.value.workspace_plan_access_emails, [])

}