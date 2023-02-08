data "amazon-ami" "base_image" {
  region = "ap-northeast-2"
  filters = {
    name                = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
    root-device-type    = "ebs"
  }
  most_recent = true
  owners      = ["099720109477"]
}

source "amazon-ebs" "example" {
  region = "ap-northeast-2"
  source_ami     = data.amazon-ami.base_image.id
  #source_ami              = "ami-013218fccb68a90d4"
  instance_type           = "t2.micro"
  ssh_username            = "ubuntu"
  ami_name                = "learn_packer_{{timestamp}}"
}

build {
  /* hcp_packer_registry {
    bucket_name = "hcp-packer-demo"
    description = "Super simple static website"

    bucket_labels = {
      "hashitalks" = "2022"
      "author" = "Caleb Albers"
    }

    build_labels = {
      "foo-version" = "1.4.2",
    }
  } */

  sources = ["source.amazon-ebs.example"]

  // move binary to desired directory
  provisioner "shell" {
    script = "./packer/app.sh"
  }

  provisioner "ansible-local" {
      command = "ansible-playbook"
      #playbook_file = "../playbooks/install-apt.yml"
      #playbook_file = "./playbooks/playbook.yml"
      playbook_file = "./playbooks/roles/create_usergrp.yml"
  }

  post-processor "manifest" {
    output     = "packer_manifest.json"
    strip_path = true
    custom_data = {
      iteration_id = packer.iterationID
    }
  }
}
