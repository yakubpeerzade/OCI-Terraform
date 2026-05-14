#############################
# DRG
#############################
# module "dev_drg" {
#   source = "../../modules/drg"

#   compartment_id = var.compartment_id
#   display_name   = "dev-drg"
# }

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

  subnet_name    = "hub-management-subnet"
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

  subnet_name    = "dmz-public-lb-subnet"
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

  subnet_name    = "spoke-app-subnet"
  cidr_block     = "172.28.98.0/28"
  dns_label      = "spkapp"
  is_private     = true
  route_table_id = module.spoke_route_table.route_table_id
}

module "spoke_db_subnet" {
  source = "../../modules/subnet"

  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id

  subnet_name    = "spoke-db-subnet"
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
  gateway_name   = "dmz-dev-igw"
  gateway_type   = "igw"
}

module "hub_nat_gateway" {
  source         = "../../modules/gateway"
  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id
  gateway_name   = "hub-dev-nat"
  gateway_type   = "nat"
}

module "hub_service_gateway" {
  source         = "../../modules/gateway"
  compartment_id = var.compartment_id
  vcn_id         = module.hub_vcn.vcn_id
  gateway_name   = "hub-dev-sgw"
  gateway_type   = "sgw"
}

#############################
# DRG Attachments
#############################
module "hub_drg_attachment" {
  source = "../../modules/drg-attachment"

  drg_id       = var.drg_id # Updated reference
  vcn_id       = module.hub_vcn.vcn_id
  display_name = "hub-dev-drg-attachment"
}

module "dmz_drg_attachment" {
  source = "../../modules/drg-attachment"

  drg_id       = var.drg_id # Updated reference
  vcn_id       = module.dmz_vcn.vcn_id
  display_name = "dmz-dev-drg-attachment"
}

module "spoke_drg_attachment" {
  source = "../../modules/drg-attachment"

  drg_id       = var.drg_id # Updated reference
  vcn_id       = module.spoke_vcn.vcn_id
  display_name = "spoke-dev-drg-attachment"
}

#############################
# VCN Route Tables
#############################
#############################
# HUB Route Table
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
    },
    {
      destination       = "172.28.99.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id # FIXED Reference
    },
    {
      destination       = "172.28.98.0/26"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id # FIXED Reference
    },
    {
      destination       = "10.100.1.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id # FIXED Reference
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
    },
    {
      destination       = "172.28.96.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id # FIXED Reference
    },
    {
      destination       = "172.28.98.0/26"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id # FIXED Reference
    },
    {
      destination       = "10.100.1.0/24"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id # FIXED Reference
    }
  ]
}

module "spoke_route_table" {
  source = "../../modules/route-table"

  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id
  display_name   = "spoke-route-table"

  route_rules = [
    {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = var.drg_id # Updated reference
    }
  ]
}

#############################
# DRG Route Tables
#############################
module "hub_drg_route_table" {
  source = "../../modules/drg-route-table"

  drg_id       = var.drg_id # Updated reference
  display_name = "hub-dev-drg-route-table"
}

module "spoke_drg_route_table" {
  source = "../../modules/drg-route-table"

  drg_id       = var.drg_id # Updated reference
  display_name = "spoke-dev-drg-route-table"
}

module "dmz_drg_route_table" {
  source = "../../modules/drg-route-table"

  drg_id       = var.drg_id # Updated reference
  display_name = "dmz-dev-drg-route-table"
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
# DRG Transit Routes (Force Spoke & DMZ traffic through Hub)
#############################################################

# 1. Route all traffic leaving the Spoke VCN into the Hub VCN Attachment
module "spoke_to_hub_route" {
  source                     = "../../modules/drg-route-rule"
  drg_route_table_id         = module.spoke_drg_route_table.drg_route_table_id
  destination                = "0.0.0.0/0"
  next_hop_drg_attachment_id = module.hub_drg_attachment.drg_attachment_id
}

# 2. Route traffic leaving the DMZ VCN destined for Hub into Hub VCN Attachment
module "dmz_to_hub_route" {
  source                     = "../../modules/drg-route-rule"
  drg_route_table_id         = module.dmz_drg_route_table.drg_route_table_id
  destination                = "172.28.96.0/24"
  next_hop_drg_attachment_id = module.hub_drg_attachment.drg_attachment_id
}

# 3. Route traffic leaving the DMZ VCN destined for Spoke into Hub VCN Attachment (Inspection)
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
  display_name   = "web-nsg"
}

module "app_nsg" {
  source         = "../../modules/nsg"
  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id
  display_name   = "app-nsg"
}

module "db_nsg" {
  source         = "../../modules/nsg"
  compartment_id = var.compartment_id
  vcn_id         = module.spoke_vcn.vcn_id
  display_name   = "db-nsg"
}

#################################
# Availability Domains Data Source
#################################
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

#################################
# Spoke Test VM (Direct Resource)
#################################
resource "oci_core_instance" "spoke_test_vm" {
  # Dynamically assign the first valid Availability Domain name for your tenancy
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_id
  shape               = var.shape
  display_name        = "spoke-dev-test-vm"

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