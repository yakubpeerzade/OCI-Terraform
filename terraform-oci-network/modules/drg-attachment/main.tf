resource "oci_core_drg_attachment" "this" {
  drg_id       = var.drg_id
  vcn_id       = var.vcn_id
  display_name = var.display_name
}