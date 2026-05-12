resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id

  cidr_blocks = var.cidr_blocks

  display_name = var.vcn_name
  dns_label    = var.dns_label
}