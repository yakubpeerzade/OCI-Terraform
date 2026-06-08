# 1. Execute the bash script to fetch the token and write the OCI config files on the runner disk
data "external" "oci_token" {
  program = ["bash", "${path.module}/exchange_token.sh"]
}

# 2. Configure the OCI provider to read the dynamically written configuration profile
provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = data.external.oci_token.result["profile"] # Creates a direct dependency chain
  region              = var.region 
}