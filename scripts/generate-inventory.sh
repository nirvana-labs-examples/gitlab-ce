#!/bin/bash
# Generate Ansible inventory from Terraform output

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TERRAFORM_DIR="$SCRIPT_DIR/../terraform"
ANSIBLE_DIR="$SCRIPT_DIR/../ansible"

cd "$TERRAFORM_DIR"

VM_IP=$(terraform output -raw vm_public_ip)

cat > "$ANSIBLE_DIR/inventory.ini" <<EOF
[gitlab]
gitlab-ce ansible_host=$VM_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_ed25519
EOF

echo "Inventory generated at $ANSIBLE_DIR/inventory.ini"
echo "VM Public IP: $VM_IP"
