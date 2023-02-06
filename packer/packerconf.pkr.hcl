packer {
  required_version = ">=1.8.3"
  required_plugins {
    amazon = {
      version = ">= 1.0.8"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = ">= 1.0.2"
      source  = "github.com/hashicorp/ansible"
    }
  }
}
