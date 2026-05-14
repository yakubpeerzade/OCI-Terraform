variable "region" {
  type = string
}

variable "compartment_id" {
  type = string
}

# Explicitly declares the shared DRG ID variable expected by main.tf
variable "drg_id" {
  type        = string
  description = "The OCID of the shared DRG created in the common environment"
}

variable "oracle_linux_image_id" {
  type        = string
  description = "The OCID of the Oracle Linux image"
}

variable "shape" {
  type        = string
  default     = "VM.Standard.E4.Flex"
  description = "Compute instance shape"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for VM access"
}