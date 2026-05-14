<div align="center">
  <a href="https://nirvanalabs.io">
    <img src="https://nirvanalabs.io/brand-kit/logo/nirvana-logo-color-black-text.svg" alt="Nirvana Labs" width="320" />
  </a>

  [Sign Up](https://nirvanalabs.io/sign-up) · [Docs](https://docs.nirvanalabs.io) · [API](https://docs.nirvanalabs.io/api) · [Examples](https://github.com/nirvana-labs-examples) · [Terraform](https://registry.terraform.io/providers/nirvana-labs/nirvana/latest) · [TypeScript SDK](https://www.npmjs.com/package/@nirvana-labs/nirvana) · [Go SDK](https://github.com/Nirvana-Labs/nirvana-go) · [CLI](https://github.com/nirvana-labs/nirvana-cli) · [MCP](https://www.npmjs.com/package/@nirvana-labs/nirvana-mcp)
</div>

---

# GitLab CE on Nirvana Labs

Deploy GitLab Community Edition on Nirvana Labs cloud infrastructure.

## Structure

```
.
├── terraform/          # Infrastructure provisioning
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ansible/            # GitLab CE installation
│   ├── playbook.yml
│   ├── ansible.cfg
│   └── inventory.ini.example
├── scripts/
│   └── generate-inventory.sh
└── README.md
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) >= 2.9
- Nirvana Labs account and API key
- SSH key pair

## Resources Created

| Resource | Specification |
|----------|---------------|
| VPC | With subnet in us-sva-2 |
| Firewall | Ports 22, 80, 443 |
| VM | 4 vCPU, 8 GB RAM, 64 GB SSD |

## Quick Start

### 1. Provision Infrastructure

```bash
cd terraform

export NIRVANA_LABS_API_KEY="your-api-key"

terraform init
terraform plan -var='ssh_public_key=ssh-ed25519 AAAA...' -var='project_id=your-project-id'
terraform apply -var='ssh_public_key=ssh-ed25519 AAAA...' -var='project_id=your-project-id'
```

Note the `vm_public_ip` output.

### 2. Install GitLab CE

Choose one of the following methods:

---

#### Option A: Ansible (Recommended)

```bash
# Generate inventory from terraform output
cd ..
./scripts/generate-inventory.sh

# Run playbook
cd ansible
ansible-playbook playbook.yml
```

The playbook will display the initial root password when complete.

---

#### Option B: Manual Installation

SSH into the VM and run:

```bash
ssh ubuntu@<vm_public_ip>

# Install dependencies
sudo apt update
sudo apt install -y curl openssh-server ca-certificates tzdata perl

# Add GitLab repository
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.deb.sh | sudo bash

# Install GitLab CE
sudo EXTERNAL_URL="http://<vm_public_ip>" apt install gitlab-ce

# Get initial root password
sudo cat /etc/gitlab/initial_root_password
```

---

### 3. Access GitLab

1. Open `http://<vm_public_ip>` in your browser
2. Login with:
   - Username: `root`
   - Password: (from initial_root_password file, valid for 24 hours)

## Terraform Variables

| Name | Description | Default |
|------|-------------|---------|
| `project_id` | Nirvana Labs project ID | - |
| `region` | Deployment region | `us-sva-2` |
| `vm_name` | VM name | `gitlab-ce` |
| `vcpu` | Number of vCPUs | `4` |
| `memory_gb` | Memory in GB | `8` |
| `boot_volume_gb` | Boot volume in GB (min 64) | `64` |
| `ssh_public_key` | SSH public key | - |

## Outputs

| Name | Description |
|------|-------------|
| `vm_id` | GitLab VM ID |
| `vm_public_ip` | GitLab VM public IP |
| `vpc_id` | VPC ID |

## Clean Up

```bash
cd terraform
terraform destroy -var='ssh_public_key=...' -var='project_id=...'
```

## License

Apache 2.0 — see [LICENSE](LICENSE.md).
