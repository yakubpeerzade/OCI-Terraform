output "drg_id" {
  value = module.dev_drg.drg_id
}

output "hub_vcn_id" {
  value = module.hub_vcn.vcn_id
}

output "dmz_vcn_id" {
  value = module.dmz_vcn.vcn_id
}

output "spoke_vcn_id" {
  value = module.spoke_vcn.vcn_id
}