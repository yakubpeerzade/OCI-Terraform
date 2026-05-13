variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment"
}

variable "availability_domain" {
  type        = string
  description = "The Availability Domain where the VM will be provisioned"
}

variable "shape" {
  type        = string
  default     = "VM.Standard.E4.Flex"
  description = "The compute instance shape"
}

variable "display_name" {
  type        = string
  description = "The friendly name of the instance"
}

variable "subnet_id" {
  type        = string
  description = "The OCID of the target subnet"
}

variable "assign_public_ip" {
  type        = bool
  default     = false
  description = "Whether to assign a public IP address to the primary VNIC"
}

variable "nsg_ids" {
  type        = list(string)
  default     = []
  description = "List of Network Security Group OCIDs to attach to the VM"
}

variable "image_id" {
  type        = string
  description = "The OCID of the source image (e.g., Oracle Linux)"
}

variable "ocpus" {
  type        = number
  default     = 1
  description = "Number of OCPUs for Flex shapes"
}

variable "memory_in_gbs" {
  type        = number
  default     = 6
  description = "Amount of Memory in GBs for Flex shapes"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for remote access"
}