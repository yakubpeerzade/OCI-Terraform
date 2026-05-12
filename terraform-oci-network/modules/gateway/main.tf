resource "oci_core_internet_gateway" "igw" {
  count = var.gateway_type == "igw" ? 1 : 0

  compartment_id = var.compartment_id

  vcn_id = var.vcn_id

  display_name = var.gateway_name

  enabled = true
}

resource "oci_core_nat_gateway" "nat" {
  count = var.gateway_type == "nat" ? 1 : 0

  compartment_id = var.compartment_id

  vcn_id = var.vcn_id

  display_name = var.gateway_name
}

resource "oci_core_service_gateway" "sgw" {
  count = var.gateway_type == "sgw" ? 1 : 0

  compartment_id = var.compartment_id

  vcn_id = var.vcn_id

  display_name = var.gateway_name

  services {
    service_id = data.oci_core_services.all_services.services[0].id
  }
}

data "oci_core_services" "all_services" {
}