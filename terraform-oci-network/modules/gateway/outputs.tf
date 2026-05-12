output "gateway_id" {
  value = try(
    oci_core_internet_gateway.igw[0].id,
    oci_core_nat_gateway.nat[0].id,
    oci_core_service_gateway.sgw[0].id
  )
}