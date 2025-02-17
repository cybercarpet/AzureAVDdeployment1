variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "Central Europe"
}

variable "session_host_count" {
  description = "Number of session hosts to deploy"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Administrator username for the session hosts"
  type        = string
}

variable "admin_password" {
  description = "Administrator password for the session hosts"
  type        = string
  sensitive   = true
}
