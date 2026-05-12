variable "compartment_id" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "display_name" {
  type = string
}

variable "route_rules" {
  type = list(object({
    destination       = string
    destination_type  = string
    network_entity_id = string
  }))
}