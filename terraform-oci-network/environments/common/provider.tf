# 1. Execute the bash script to exchange the TFC token for the OCI token
data "external" "oci_token" {
  program = ["bash", "${path.module}/exchange_token.sh"]
}

# 2. Configure the OCI provider to use the generated token
provider "oci" {
  auth   = "SecurityToken"
  token  = data.external.oci_token.result["access_token"] # CHANGED HERE
  region = var.region 
}