variable "compartment_id" {
  type = string
}

variable "region" {
  type = string
}
variable "availability_domain" {}
variable "image_id" {}

#####VM############
variable "availability_domain" {
  type = string
}

variable "compartment_id" {
  type = string
}

variable "shape" {
  type = string
}

variable "display_name" {
  type = string
}

variable "subnet_id" {
  type = string
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