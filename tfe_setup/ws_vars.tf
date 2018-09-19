variable "chef_env" {
    type="string"
}
resource "tfe_variable" "chef_env" {
    key = "chef_env"
    value = "${var.chef_env}"
    category = "terraform"
    workspace_id = "${module.workspace.workspace_id}"
}

variable "region" {
    type="string"
}
resource "tfe_variable" "region" {
    key = "region"
    value = "${var.region}"
    category = "terraform"
    workspace_id = "${module.workspace.workspace_id}"
}

variable "service_name" {
    type="string"
}
resource "tfe_variable" "service_name" {
    key = "service_name"
    value = "${var.service_name}"
    category = "terraform"
    workspace_id = "${module.workspace.workspace_id}"
}

variable "service_version" {
    type="string"
}
resource "tfe_variable" "service_version" {
    key = "service_version"
    value = "${var.service_version}"
    category = "terraform"
    workspace_id = "${module.workspace.workspace_id}"
}
variable "vault_chef_credentials_path" {
    type="string"
}
resource "tfe_variable" "vault_chef_credentials_path" {
    key = "vault_chef_credentials_path"
    value = "${var.vault_chef_credentials_path}"
    category = "terraform"
    workspace_id = "${module.workspace.workspace_id}"
}

variable "cloud_provider" {
    type="string"
}
resource "tfe_variable" "cloud_provider" {
    key = "cloud_provider"
    value = "${var.cloud_provider}"
    category = "terraform"
    workspace_id = "${module.workspace.workspace_id}"
}