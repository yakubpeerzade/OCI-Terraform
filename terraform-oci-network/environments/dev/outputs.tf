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

output "dmz_igw_id" {
  value = module.dmz_igw.gateway_id
}

output "hub_nat_gateway_id" {
  value = module.hub_nat_gateway.gateway_id
}

output "hub_service_gateway_id" {
  value = module.hub_service_gateway.gateway_id
}
output "hub_drg_attachment_id" {
  value = module.hub_drg_attachment.drg_attachment_id
}

output "dmz_drg_attachment_id" {
  value = module.dmz_drg_attachment.drg_attachment_id
}

output "spoke_drg_attachment_id" {
  value = module.spoke_drg_attachment.drg_attachment_id
}

output "hub_route_table_id" {
  value = module.hub_route_table.route_table_id
}

output "dmz_route_table_id" {
  value = module.dmz_route_table.route_table_id
}

output "spoke_route_table_id" {
  value = module.spoke_route_table.route_table_id
}

output "app_nsg_id" {
  value = module.app_nsg.nsg_id
}

output "web_nsg_id" {
  value = module.web_nsg.nsg_id
}

output "db_nsg_id" {
  value = module.db_nsg.nsg_id
}

output "spoke_test_vm_instance_id" {
  value = module.spoke_test_vm.instance_id
}