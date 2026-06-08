# 1. Execute the bash script to exchange the TFC token for the OCI token
data "external" "oci_token" {
  program = ["bash", "${path.module}/exchange_token.sh"]
}

# 2. Configure the OCI provider to read the dynamic profile configuration
provider "oci" {
  auth                = "SecurityToken"
  config_file_profile = data.external.oci_token.result["profile"] # Forces script execution first
  region              = var.region 
}