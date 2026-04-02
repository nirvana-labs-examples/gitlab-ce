variable "project_id" {
  description = "Nirvana Labs project ID"
  type        = string
  default     = null
}

variable "region" {
  description = "Region to deploy resources"
  type        = string
  default     = "us-sva-2"
}

variable "vm_name" {
  description = "Name of the GitLab VM"
  type        = string
  default     = "gitlab-ce"
}

variable "vcpu" {
  description = "Number of vCPUs"
  type        = number
  default     = 4
}

variable "memory_gb" {
  description = "Memory size in GB"
  type        = number
  default     = 8
}

variable "boot_volume_gb" {
  description = "Boot volume size in GB (min 64 for ABS)"
  type        = number
  default     = 64
}

variable "os_image" {
  description = "OS image name"
  type        = string
  default     = "ubuntu-noble-2025-10-01"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = list(string)
  default     = ["gitlab"]
}
