resource "oci_core_drg_route_table_route_rule" "this" {
  drg_route_table_id         = var.drg_route_table_id
  destination                = var.destination
  destination_type           = "CIDR_BLOCK"
  next_hop_drg_attachment_id = var.next_hop_drg_attachment_id
}