variable "region" {
  type = string
}

#####VM############
variable "availability_domain" {
  type = string
}

variable "compartment_id" {
  type = string
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



