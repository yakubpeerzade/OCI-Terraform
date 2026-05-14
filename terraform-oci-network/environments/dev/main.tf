#############################
# HUB VCN
#############################
module "hub_vcn" {
  source = "../../modules/vcn"

  compartment_id = var.compartment_id

  vcn_name    = "dbxpass-vcn-hub-dev"
  cidr_blocks = ["172.28.96.0/24"]
  dns_label   = "hubdev"
}

#############################
# DMZ VCN
#############################
module "dmz_vcn" {
  source = "../../modules/vcn"

  compartment_id = var.compartment_id

  vcn_name    = "dbxpass-vcn-dmz-dev"
  cidr_blocks = ["172.28.99.0/24"]
  dns_label   = "dmzdev"
}

#############################
# SPOKE VCN
#############################
module "spoke_vcn" {
  source = "../../modules/vcn"

  compartment_id = var.compartment_id

  vcn_name    = "dbxpass-vcn-spoke-dev"
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

  subnet_name    = "dbxpass-subnet-hub-mgmt-dev"
  cidr_block     = "172.28.96.16/28"
  dns_label      = "hubmgmt"
  is_private     = true
  route_table_id = module.hub_route_table.route_table_id
}

#############################
# DMZ VCN SUBNETS
#############################
module "dmz_public_lb_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.dmz_vcn.vcn_id

  subnet_name    = "dbxpass-subnet-dmz-pub-lb-dev"
  cidr_block     = "172.28.99.0/28"
  dns_label      = "dmzpub"
  is_private     = false
  route_table_id = module.dmz_route_table.route_table_id
}

#############################
# SPOKE VCN SUBNETS
#############################
module "spoke_app_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id

  subnet_name    = "dbxpass-subnet-spoke-app-dev"
  cidr_block     = "172.28.98.0/28"
  dns_label      = "spkapp"
  is_private     = true
  route_table_id = module.spoke_route_table.route_table_id
}

module "spoke_db_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id

  subnet_name    = "dbxpass-subnet-spoke-db-dev"
  cidr_block     = "172.28.98.16/28"
  dns_label      = "spkdb"
  is_private     = true
  route_table_id = module.spoke_route_table.route_table_id
}

#############################
# GATEWAYS
#############################
module "dmz_igw" {
  source         = "../../modules/gateway"
  compartment_id = var.compartment_id
  vcn_id         = module.dmz_vcn.vcn_id
  gateway_name   = "dbxpass-igw-dmz-dev"
  gateway_type   = "igw"
}

module "hub_nat_gateway" {
  source         = "../../modules/gateway"
  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id
  gateway_name   = "dbxpass-nat-hub-dev"
  gateway_type   = "nat"
}

module "hub_service_gateway" {
  source         = "../../modules/gateway"
  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id
  gateway_name   = "dbxpass-sgw-hub-dev"
  gateway_type   = "sgw"
}

#############################
# DRG Attachments
#############################
module "hub_drg_attachment" {
  source       = "../../modules/drg-attachment"
  drg_id       = var.drg_id
  vcn_id       = module.hub_vcn.vcn_id
  display_name = "dbxpass-drg-attach-hub-dev"
}

module "dmz_drg_attachment" {
  source       = "../../modules/drg-attachment"
  drg_id       = var.drg_id
  vcn_id       = module.dmz_vcn.vcn_id
  display_name = "dbxpass-drg-attach-dmz-dev"
}

module "spoke_drg_attachment" {
  source       = "../../modules/drg-attachment"
  drg_id       = var.drg_id
  vcn_id       = module.spoke_vcn.vcn_id
  display_name = "dbxpass-drg-attach-spoke-dev"
}

#############################
# VCN Route Tables
#############################
module "hub_route_table" {
  source         = "../../modules/route-table"
  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id
  display_name   = "dbxpass-rt-hub-dev"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.hub_nat_gateway.gateway_id
    },
    {
      destination       = "172.28.99.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id
    },
    {
      destination       = "172.28.98.0/26"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id
    },
    {
      destination       = "10.100.1.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id
    }
  ]
}

module "dmz_route_table" {
  source         = "../../modules/route-table"
  compartment_id = var.compartment_id
  vcn_id         = module.dmz_vcn.vcn_id
  display_name   = "dbxpass-rt-dmz-dev"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = module.dmz_igw.gateway_id
    },
    {
      destination       = "172.28.96.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id
    },
    {
      destination       = "172.28.98.0/26"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id
    },
    {
      destination       = "10.100.1.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id
    }
  ]
}

module "spoke_route_table" {
  source         = "../../modules/route-table"
  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id
  display_name   = "dbxpass-rt-spoke-dev"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id
    }
  ]
}

#############################
# DRG Route Tables
#############################
module "hub_drg_route_table" {
  source       = "../../modules/drg-route-table"
  drg_id       = var.drg_id
  display_name = "dbxpass-drg-rt-hub-dev"
}

module "spoke_drg_route_table" {
  source       = "../../modules/drg-route-table"
  drg_id       = var.drg_id
  display_name = "dbxpass-drg-rt-spoke-dev"
}

module "dmz_drg_route_table" {
  source       = "../../modules/drg-route-table"
  drg_id       = var.drg_id
  display_name = "dbxpass-drg-rt-dmz-dev"
}

#############################
# DRG Route Table Associations
#############################
module "hub_drg_rt_assoc" {
  source             = "../../modules/drg-route-table-association"
  drg_attachment_id  = module.hub_drg_attachment.drg_attachment_id
  drg_route_table_id = module.hub_drg_route_table.drg_route_table_id
}

module "spoke_drg_rt_assoc" {
  source             = "../../modules/drg-route-table-association"
  drg_attachment_id  = module.spoke_drg_attachment.drg_attachment_id
  drg_route_table_id = module.spoke_drg_route_table.drg_route_table_id
}

module "dmz_drg_rt_assoc" {
  source             = "../../modules/drg-route-table-association"
  drg_attachment_id  = module.dmz_drg_attachment.drg_attachment_id
  drg_route_table_id = module.dmz_drg_route_table.drg_route_table_id
}

#############################################################
# DRG Transit Routes
#############################################################
module "spoke_to_hub_route" {
  source                     = "../../modules/drg-route-rule"
  drg_route_table_id         = module.spoke_drg_route_table.drg_route_table_id
  destination                = "0.0.0.0/0"
  next_hop_drg_attachment_id = module.hub_drg_attachment.drg_attachment_id
}

module "dmz_to_hub_route" {
  source                     = "../../modules/drg-route-rule"
  drg_route_table_id         = module.dmz_drg_route_table.drg_route_table_id
  destination                = "172.28.96.0/24"
  next_hop_drg_attachment_id = module.hub_drg_attachment.drg_attachment_id
}

module "dmz_to_spoke_route" {
  source                     = "../../modules/drg-route-rule"
  drg_route_table_id         = module.dmz_drg_route_table.drg_route_table_id
  destination                = "172.28.98.0/26"
  next_hop_drg_attachment_id = module.hub_drg_attachment.drg_attachment_id
}

##############################
# NSGs
##############################
module "web_nsg" {
  source         = "../../modules/nsg"
  compartment_id = var.compartment_id
  vcn_id         = module.dmz_vcn.vcn_id
  display_name   = "dbxpass-nsg-web-dev"
}

module "app_nsg" {
  source         = "../../modules/nsg"
  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id
  display_name   = "dbxpass-nsg-app-dev"
}

module "db_nsg" {
  source         = "../../modules/nsg"
  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id
  display_name   = "dbxpass-nsg-db-dev"
}

#################################
# Availability Domains Data Source
#################################
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

#################################
# Spoke Test VM
#################################
resource "oci_core_instance" "spoke_test_vm" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.shape
  display_name        = "dbxpass-vm-spoke-test-dev"

  create_vnic_details {
    subnet_id = module.spoke_app_subnet.subnet_id
    nsg_ids   = [module.app_nsg.nsg_id]
  }

  source_details {
    source_type = "image"
    source_id   = var.oracle_linux_image_id
  }

  shape_config {
    ocpus         = 1
    memory_in_gbs = 6
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }
}