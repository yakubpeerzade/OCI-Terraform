resource "oci_core_drg_route_table_attachment" "this" {
  drg_attachment_id  = var.drg_attachment_id
  drg_route_table_id = var.drg_route_table_id
}