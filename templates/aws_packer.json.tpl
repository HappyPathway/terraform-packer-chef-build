{
    "variables": {
      "instance_type": "m4.large",
      "chef_validation_key": "${CHEF_VALIDATION_KEY}",
      "chef_client_name": "${CHEF_VALIDATION_CLIENT_NAME}",
      "chef_server_url": "${CHEF_SERVER_URL}",
      "chef_encrypted_data_bag_secret": "${CHEF_ENCRYPTED_DATA_BAG_SECRET}",
      "chef_env": "${CHEF_ENV}",
      "working_dir": "{{env `PWD` }}",
      "home_dir": "{{env `HOME` }}",
      "service_name": "${SERVICE_NAME}",
      "service_version": "${SERVICE_VERSION}",
      "region": "${REGION}"
    },
    "builders": [
      {
        "type": "amazon-ebs",
        "region": "{{ user `region`}}",
        "source_ami": "{{user `source_ami`}}",
        "instance_type": "{{user `instance_type`}}",
        "force_deregister": true,
        "force_delete_snapshot": true,
        "ssh_username": "ubuntu",
        "ami_name": "{{ user `service_name`}}-{{ user `service_version`}}",
        "ami_groups": "all",
        "run_tags": {
          "Name": "Packer-{{ user `service_name`}}-{{ user `service_version`}}"
        },
        "tags": {
          "service_name": "{{ user `service_name`}}",
          "service_version": "{{user `service_version`}}"
        },
        "source_ami_filter": {
            "filters": {
              "virtualization-type": "hvm",
              "name": "ubuntu/images/*ubuntu-xenial-16.04-amd64-server-*",
              "root-device-type": "ebs"
            },
            "owners": ["099720109477"],
            "most_recent": true
        }
      }
    ],
    "provisioners": [
      {
          "type": "shell",
          "inline": [
            "sudo apt-get update",
            "mkdir -p /tmp/packer-chef-client"
          ]
      },
      {
          "type": "file",
          "source": "{{user `chef_encrypted_data_bag_secret`}}",
          "destination": "/tmp/packer-chef-client/encrypted_data_bag_secret"
      },
      {
          "type": "chef-client",
          "server_url": "{{user `chef_server_url`}}",
          "chef_environment": "{{ user `chef_env`}}",
          "run_list": "recipe[{{ user `service_name` }}]",
          "ssl_verify_mode": "verify_none",
          "validation_key_path": "{{user `chef_validation_key` }}",
          "validation_client_name": "{{user `chef_client_name` }}",
          "json": {
            "encrypted_data_bag_secret_path": "/tmp/packer-chef-client/encrypted_data_bag_secret"
          }
      }
    ]
  }
  

