variable "compartment_id" {
  type = string
}

variable "vcn_name" {
  type = string
}

variable "cidr_blocks" {
  type = list(string)
}

variable "dns_label" {
  type = string
}