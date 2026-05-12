resource "oci_core_drg_route_table" "this" {
  drg_id       = var.drg_id
  display_name = var.display_name
}