variable "organization" {
    type="string"
    description="Name of Terraform Enterprise Organization"
}


variable "github_org" {
    type="string"
    description="Github Organization"
}


variable "vault_token" {
    type="string"
    description="Vault Token"
}


variable "vault_addr" {
    type="string"
    description="Vault Cluster Address"
}


variable "repo_name" {
    type="string"
    description="Name of Github Repo"
}


variable "workspace_name" {
    type="string"
    description="Name of TFE Workspace"
}


variable "oauth_token" {
    type="string"
    description="Terraform Enterprise VCS Oauth Token"
}


module "workspace" {
    source  = "app.terraform.io/Darnold-Hashicorp/demo-workspace/tfe"
    version = "2.1.0"
    github_org = "${var.github_org}"
    oauth_token = "${var.oauth_token}"
    organization = "${var.organization}"
    repo_name = "${var.repo_name}"
    workspace_name ="${var.workspace_name}"
    aws_vars = true
    azure_vars = true
    vault_vars = true
    vault_addr = "${var.vault_addr}"
    vault_token = "${var.vault_token}"
    create_repo = false
}