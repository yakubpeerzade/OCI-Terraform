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

module "hub_firewall_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  subnet_name = "hub-firewall-subnet"

  cidr_block = "172.28.96.0/28"

  dns_label = "hubfw"

  is_private = true
}

module "hub_management_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  subnet_name = "hub-management-subnet"

  cidr_block = "172.28.96.16/28"

  dns_label = "hubmgmt"

  is_private = true
}

module "hub_shared_services_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  subnet_name = "hub-shared-services-subnet"

  cidr_block = "172.28.96.32/27"

  dns_label = "hubshared"

  is_private = true
}

#############################
# HUB VCN SUBNETS
#############################

module "hub_firewall_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  subnet_name = "hub-firewall-subnet"

  cidr_block = "172.28.96.0/28"

  dns_label = "hubfw"

  is_private = true
}

module "hub_management_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  subnet_name = "hub-management-subnet"

  cidr_block = "172.28.96.16/28"

  dns_label = "hubmgmt"

  is_private = true
}

module "hub_shared_services_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.hub_vcn.vcn_id

  subnet_name = "hub-shared-services-subnet"

  cidr_block = "172.28.96.32/27"

  dns_label = "hubshared"

  is_private = true
}

#############################
# DMZ VCN SUBNETS
#############################

module "dmz_public_lb_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.dmz_vcn.vcn_id

  subnet_name = "dmz-public-lb-subnet"

  cidr_block = "172.28.99.0/28"

  dns_label = "dmzpub"

  is_private = false
}

module "dmz_web_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.dmz_vcn.vcn_id

  subnet_name = "dmz-web-subnet"

  cidr_block = "172.28.99.16/28"

  dns_label = "dmzweb"

  is_private = true
}

#############################
# SPOKE VCN SUBNETS
#############################

module "spoke_app_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.spoke_vcn.vcn_id

  subnet_name = "spoke-app-subnet"

  cidr_block = "172.28.98.0/28"

  dns_label = "spkapp"

  is_private = true
}

module "spoke_db_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id

  vcn_id = module.spoke_vcn.vcn_id

  subnet_name = "spoke-db-subnet"

  cidr_block = "172.28.98.16/28"

  dns_label = "spkdb"

  is_private = true
}