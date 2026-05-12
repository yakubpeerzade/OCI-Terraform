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

output "hub_firewall_subnet_id" {
  value = module.hub_firewall_subnet.subnet_id
}

output "hub_management_subnet_id" {
  value = module.hub_management_subnet.subnet_id
}

output "hub_shared_services_subnet_id" {
  value = module.hub_shared_services_subnet.subnet_id
}

output "dmz_public_lb_subnet_id" {
  value = module.dmz_public_lb_subnet.subnet_id
}

output "dmz_web_subnet_id" {
  value = module.dmz_web_subnet.subnet_id
}

output "spoke_app_subnet_id" {
  value = module.spoke_app_subnet.subnet_id
}

output "spoke_db_subnet_id" {
  value = module.spoke_db_subnet.subnet_id
}