terraform {
  required_providers {
    nirvana = {
      source = "nirvana-labs/nirvana"
    }
  }
}

provider "nirvana" {}

resource "nirvana_networking_vpc" "gitlab" {
  name        = "gitlab-vpc"
  project_id  = var.project_id
  region      = var.region
  subnet_name = "gitlab-subnet"
  tags        = var.tags
}

resource "nirvana_networking_firewall_rule" "gitlab_ssh" {
  vpc_id              = nirvana_networking_vpc.gitlab.id
  name                = "gitlab-ssh"
  protocol            = "tcp"
  source_address      = "0.0.0.0/0"
  destination_address = nirvana_networking_vpc.gitlab.subnet.cidr
  destination_ports   = ["22"]
  tags                = var.tags
}

resource "nirvana_networking_firewall_rule" "gitlab_http" {
  vpc_id              = nirvana_networking_vpc.gitlab.id
  name                = "gitlab-http"
  protocol            = "tcp"
  source_address      = "0.0.0.0/0"
  destination_address = nirvana_networking_vpc.gitlab.subnet.cidr
  destination_ports   = ["80"]
  tags                = var.tags
}

resource "nirvana_networking_firewall_rule" "gitlab_https" {
  vpc_id              = nirvana_networking_vpc.gitlab.id
  name                = "gitlab-https"
  protocol            = "tcp"
  source_address      = "0.0.0.0/0"
  destination_address = nirvana_networking_vpc.gitlab.subnet.cidr
  destination_ports   = ["443"]
  tags                = var.tags
}

resource "nirvana_compute_vm" "gitlab" {
  name              = var.vm_name
  project_id        = var.project_id
  region            = var.region
  os_image_name     = var.os_image
  public_ip_enabled = true
  subnet_id         = nirvana_networking_vpc.gitlab.subnet.id
  instance_type     = var.instance_type

  boot_volume = {
    size = var.boot_volume_gb
    type = "abs"
    tags = var.tags
  }

  ssh_key = {
    public_key = var.ssh_public_key
  }

  tags = var.tags
}
