variable "compartment_id" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "subnet_name" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "dns_label" {
  type = string
}

variable "route_table_id" {
  type = string
}

variable "security_list_ids" {
  type = list(string)
  default = []
}

variable "is_private" {
  type = bool
}
