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