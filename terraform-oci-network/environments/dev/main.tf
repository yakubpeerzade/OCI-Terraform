#############################
# DRG
#############################

module "dev_drg" {
  source = "../../modules/drg"

  compartment_id = var.compartment_id
  display_name   = "dev-drg"
}

#############################
# HUB VCN
#############################

module "hub_vcn" {
  source = "../../modules/vcn"

  compartment_id = var.compartment_id

  vcn_name    = "hub-dev-vcn"
  cidr_blocks = ["172.28.96.0/24"]
  dns_label   = "hubdev"
}

#############################
# DMZ VCN
#############################

module "dmz_vcn" {
  source = "../../modules/vcn"

  compartment_id = var.compartment_id

  vcn_name    = "dmz-dev-vcn"
  cidr_blocks = ["172.28.99.0/24"]
  dns_label   = "dmzdev"
}

#############################
# SPOKE VCN
#############################

module "spoke_vcn" {
  source = "../../modules/vcn"

  compartment_id = var.compartment_id

  vcn_name    = "spoke-dev-vcn"
  cidr_blocks = ["172.28.98.0/26"]
  dns_label   = "spokedev"
}



#############################
# HUB VCN SUBNETS
#############################

module "hub_management_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id

  subnet_name = "hub-management-subnet"
  cidr_block  = "172.28.96.16/28"
  dns_label   = "hubmgmt"

  is_private = true

  route_table_id = module.hub_route_table.route_table_id
}

module "hub_firewall_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id

  subnet_name = "hub-firewall-subnet"
  cidr_block  = "172.28.96.0/28"
  dns_label   = "hubfw"

  is_private = true

  route_table_id = module.hub_route_table.route_table_id
}

module "hub_shared_services_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id

  subnet_name = "hub-shared-services-subnet"
  cidr_block  = "172.28.96.32/27"
  dns_label   = "hubshared"

  is_private = true

  route_table_id = module.hub_route_table.route_table_id
}

#############################
# DMZ VCN SUBNETS
#############################

module "dmz_public_lb_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.dmz_vcn.vcn_id

  subnet_name = "dmz-public-lb-subnet"
  cidr_block  = "172.28.99.0/28"
  dns_label   = "dmzpub"

  is_private = false

  route_table_id = module.dmz_route_table.route_table_id
}

module "dmz_web_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.dmz_vcn.vcn_id

  subnet_name = "dmz-web-subnet"
  cidr_block  = "172.28.99.16/28"
  dns_label   = "dmzweb"

  is_private = true

  route_table_id = module.dmz_route_table.route_table_id
}

#############################
# SPOKE VCN SUBNETS
#############################

module "spoke_app_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id

  subnet_name = "spoke-app-subnet"
  cidr_block  = "172.28.98.0/28"
  dns_label   = "spkapp"

  is_private = true

  route_table_id = module.spoke_route_table.route_table_id
}

module "spoke_db_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id

  subnet_name = "spoke-db-subnet"
  cidr_block  = "172.28.98.16/28"
  dns_label   = "spkdb"

  is_private = true

  route_table_id = module.spoke_route_table.route_table_id
}


#############################
# INTERNET GATEWAY
#############################

module "dmz_igw" {
  source = "../../modules/gateway"

  compartment_id = var.compartment_id

  vcn_id = module.dmz_vcn.vcn_id

  gateway_name = "dmz-dev-igw"

  gateway_type = "igw"
}

#############################
# NAT GATEWAY
#############################

module "hub_nat_gateway" {
  source = "../../modules/gateway"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  gateway_name = "hub-dev-nat"

  gateway_type = "nat"
}


#############################
# SERVICE GATEWAY
#############################

module "hub_service_gateway" {
  source = "../../modules/gateway"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  gateway_name = "hub-dev-sgw"

  gateway_type = "sgw"
}

#############################
# Hub-DRG Attachment
#############################

module "hub_drg_attachment" {
  source = "../../modules/drg-attachment"

  drg_id       = module.dev_drg.drg_id
  vcn_id       = module.hub_vcn.vcn_id
  display_name = "hub-drg-attachment"
}

#############################
# DMZ-DRG Attachment
#############################
module "dmz_drg_attachment" {
  source = "../../modules/drg-attachment"

  drg_id       = module.dev_drg.drg_id
  vcn_id       = module.dmz_vcn.vcn_id
  display_name = "dmz-drg-attachment"
}

#############################
# Spoke-DRG Attachment
#############################
module "spoke_drg_attachment" {
  source = "../../modules/drg-attachment"

  drg_id       = module.dev_drg.drg_id
  vcn_id       = module.spoke_vcn.vcn_id
  display_name = "spoke-drg-attachment"
}


#############################
# HUb Route Table
#############################
module "hub_route_table" {
  source = "../../modules/route-table"

  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id

  display_name = "hub-route-table"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.hub_nat_gateway.gateway_id
    }
  ]
}


#############################
# DMZ Route Table
#############################
module "dmz_route_table" {
  source = "../../modules/route-table"

  compartment_id = var.compartment_id
  vcn_id         = module.dmz_vcn.vcn_id

  display_name = "dmz-route-table"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.dmz_igw.gateway_id
    }
  ]
}

#############################
# Spoke Route Table
#############################
module "spoke_route_table" {
  source = "../../modules/route-table"

  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id

  display_name = "spoke-route-table"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.dev_drg.drg_id
    }
  ]
}

#############################
# DRG Route Table
#############################

module "hub_drg_route_table" {
  source = "../../modules/drg-route-table"

  drg_id       = module.dev_drg.drg_id
  display_name = "hub-drg-route-table"
}

module "spoke_drg_route_table" {
  source = "../../modules/drg-route-table"

  drg_id       = module.dev_drg.drg_id
  display_name = "spoke-drg-route-table"
}

module "dmz_drg_route_table" {
  source = "../../modules/drg-route-table"

  drg_id       = module.dev_drg.drg_id
  display_name = "dmz-drg-route-table"
}