module "shared_drg" {
  source = "../../modules/drg"

  compartment_id = var.compartment_id
  display_name   = "shared-transit-drg"
}