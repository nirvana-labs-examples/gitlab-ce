output "vm_id" {
  description = "GitLab VM ID"
  value       = nirvana_compute_vm.gitlab.id
}

output "vm_public_ip" {
  description = "GitLab VM public IP"
  value       = nirvana_compute_vm.gitlab.public_ip
}

output "vpc_id" {
  description = "VPC ID"
  value       = nirvana_networking_vpc.gitlab.id
}
