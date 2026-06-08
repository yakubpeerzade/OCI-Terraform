#!/bin/bash
# Exchanges the injected TFC token for an OCI access token

# Dynamically get the absolute folder path where this script resides
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TOKEN_RESPONSE=$(curl -s -X POST "https://idcs-7701a25968a046ebb7db1ddd6e7268ce.identity.oraclecloud.com:443/oauth2/v1/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "e965fde862964bfa8ac6e86b5bf04198:$OCI_CLIENT_SECRET" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
  -d "subject_token=$TFC_WORKLOAD_IDENTITY_TOKEN" \
  -d "subject_token_type=urn:ietf:params:oauth:token-type:jwt" \
  -d "requested_token_type=urn:ietf:params:oauth:token-type:jwt")

# Extract the access token
ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')

# Save the token to the environment directory
echo "$ACCESS_TOKEN" > "$SCRIPT_DIR/token.txt"

# Generate a dummy signing key to bypass structural client validation rules
openssl genrsa -out "$SCRIPT_DIR/key.pem" 2048 2>/dev/null

# Overwrite the placeholder oci_config file with the exact runner paths
cat << EOF > "$SCRIPT_DIR/oci_config"
[TFC_PROFILE]
tenancy=ocid1.tenancy.oc1..aaaaaaaa7kh4d2jrtkr6pvmhsm5ezqijhvesirmdmf6eb4c23u27dphz2lca
region=us-sanjose-1
security_token_file=$SCRIPT_DIR/token.txt
key_file=$SCRIPT_DIR/key.pem
EOF

# Output valid JSON with the profile name back to Terraform
jq -n --arg profile "TFC_PROFILE" '{"profile":$profile}'