#!/bin/bash
# Exchanges the injected TFC token for an OCI access token

TOKEN_RESPONSE=$(curl -s -X POST "https://idcs-7701a25968a046ebb7db1ddd6e7268ce.identity.oraclecloud.com:443/oauth2/v1/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "e965fde862964bfa8ac6e86b5bf04198:$OCI_CLIENT_SECRET" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
  -d "subject_token=$TFC_WORKLOAD_IDENTITY_TOKEN" \
  -d "subject_token_type=urn:ietf:params:oauth:token-type:jwt" \
  -d "requested_token_type=urn:ietf:params:oauth:token-type:jwt")

# Extract the access token
ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')

# Create the standard OCI configuration directory on the runner agent
mkdir -p $HOME/.oci

# Save the token to disk
echo "$ACCESS_TOKEN" > $HOME/.oci/token

# Generate a dummy signing key to bypass structural client validation rules
openssl genrsa -out $HOME/.oci/key.pem 2048 2>/dev/null

# Generate the standard configuration file layout expected by the OCI SDK
cat << EOF > $HOME/.oci/config
[TFC_PROFILE]
tenancy=ocid1.tenancy.oc1..aaaaaaaa7kh4d2jrtkr6pvmhsm5ezqijhvesirmdmf6eb4c23u27dphz2lca
region=us-sanjose-1
security_token_file=$HOME/.oci/token
key_file=$HOME/.oci/key.pem
EOF

# Output valid JSON with the profile name back to Terraform to satisfy the data contract
jq -n --arg profile "TFC_PROFILE" '{"profile":$profile}'