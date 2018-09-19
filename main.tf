data "vault_generic_secret" "chef" {
    path = "${var.vault_chef_credentials_path}"
}

resource "null_resource" "configure_chef" {
    provisioner "local-exec" {
        command = "echo '${data.vault_generic_secret.chef.data["validation_key"]}' > ${path.root}/chef_validator.pem"
    }

    provisioner "local-exec" {
        command = "echo '${data.vault_generic_secret.chef.data["encrypted_data_bag_secret"]}' > ${path.root}/chef_encrypted_data_bag_secret.pem"
    }
}

data "template_file" "packer_config" {
    depends_on = [
        "null_resource.configure_chef"
    ]
    vars = {
        CHEF_VALIDATION_KEY= "${path.root}/chef_validator.pem"
        CHEF_VALIDATION_CLIENT_NAME="${data.vault_generic_secret.chef.data["validation_client_name"]}"
        CHEF_SERVER_URL="${data.vault_generic_secret.chef.data["server_url"]}"
        CHEF_ENCRYPTED_DATA_BAG_SECRET="${path.root}/chef_encrypted_data_bag_secret.pem"
        CHEF_ENV="${var.chef_env}"
        SERVICE_NAME = "${var.service_name}"
        SERVICE_VERSION = "${var.service_version}"
        REGION = "${var.region}"
  }
  template = "${file("${path.module}/templates/${var.cloud_provider}_packer.json.tpl")}"
}

resource "null_resource" "packer_build" {
  triggers = {
      template_file   =  "${data.template_file.packer_config.rendered}"
  }

  provisioner "local-exec" {
      command = "curl -o ${path.root}/packer.zip https://releases.hashicorp.com/packer/1.2.5/packer_1.2.5_linux_amd64.zip"
  }
  provisioner "local-exec" {
      command = "unzip -d ${path.root} ${path.root}/packer.zip"
  }
  provisioner "local-exec" {
    command =  "echo '${data.template_file.packer_config.rendered}' > ${path.root}/${var.service_name}-packer.json",
  }

  provisioner "local-exec" {
      command = "${path.root}/packer build ${path.root}/${var.service_name}-packer.json"
  }

  provisioner "local-exec" {
      command = "rm ${path.root}/${var.service_name}-packer.json"
  }

  provisioner "local-exec" {
      command = "rm ${path.root}/packer; rm ${path.root}/packer.zip"
  }
}



data "azurerm_image" "image" {
  name                = "${var.service_name}-${var.service_version}"
  resource_group_name = "PackerConfigs"
  depends_on = [
      "null_resource.packer_build"
  ]
}