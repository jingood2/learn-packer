packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }

}

source "amazon-ebs" "cocktails" {
  ami_name      = "cocktails"
  source_ami    = "ami-013a129d325529d4d"
  instance_type = "t2.micro"
  region        = "us-west-2"
  ssh_username  = "ec2-user"

}

build {
  sources = [
    "source.amazon-ebs.cocktails"
  ]

  provisioner "shell" {
    script = "./app.sh"
  }

}