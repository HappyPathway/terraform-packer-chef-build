{
    "variables": {
        "client_id": "{{enc `ARM_CLIENT_ID`}}",
        "client_secret": "{{env `ARM_CLIENT_SECRET`}}",
        "subscription_id": "{{env `ARM_SUBSCRIPTION_ID`}}",
        "tenant_id": "{{env `ARM_TENANT_ID`}}",
        "service_name": "${SERVICE_NAME}",
        "service_version": "${SERVICE_VERSION}",
        "location": "${LOCATION}",
        "working_dir": "{{env `PWD`}}",
        "home_dir": "{{env `HOME`}}",
        "local_salt_tree": "${LOCAL_SALT_TREE}"
    },
    "builders": [
        {
            "type": "azure-arm",
            "subscription_id": "{{user `subscription_id`}}",
            "client_id": "{{user `client_id`}}",
            "client_secret": "{{user `client_secret`}}",
            "tenant_id": "{{user `tenant_id`}}",
            "location": "{{user `location`}}",

            "os_type": "Linux",
            "image_publisher": "Canonical",
            "image_offer": "UbuntuServer",
            "image_sku": "14.04.4-LTS",

            "managed_image_resource_group_name": "PackerConfigs",
            "managed_image_name": "{{user `service_name`}}-{{user `service_version`}}",

            "azure_tags": {
                "service": "{{user `service_name` }}",
                "version": "{{user `service_version` }}"
            },
            "vm_size": "Standard_A2"
        }
    ],
    "provisioners": [
        {
            "type": "salt-masterless",
            "local_state_tree": "{{user `local_salt_tree`}}"
        },
        {
            "execute_command": "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'",
            "inline": [
                "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
            ],
            "inline_shebang": "/bin/sh -x",
            "type": "shell"
        }
    ]
}

