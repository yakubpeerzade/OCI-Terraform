data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}
resource "oci_core_subnet" "this" {
  compartment_id = var.compartment_id

  vcn_id = var.vcn_id

  display_name = var.subnet_name

  cidr_block = var.cidr_block

  dns_label = var.dns_label

  prohibit_public_ip_on_vnic = var.is_private

  route_table_id = module.hub_route_table.route_table_id

  security_list_ids = length(var.security_list_ids) > 0 ? var.security_list_ids : [data.oci_core_vcn.vcn.default_security_list_id]
}
