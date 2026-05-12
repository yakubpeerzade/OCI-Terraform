variable "availability_domain" {
  type = string
}

variable "compartment_id" {
  type = string
}

variable "display_name" {
  type = string
}

variable "shape" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "assign_public_ip" {
  type = bool
}

variable "nsg_ids" {
  type = list(string)
}

variable "image_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}