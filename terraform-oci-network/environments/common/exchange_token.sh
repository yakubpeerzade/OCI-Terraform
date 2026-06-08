#!/bin/bash
# Exchanges the injected TFC token for an OCI access token

TOKEN_RESPONSE=$(curl -s -X POST "https://idcs-7701a25968a046ebb7db1ddd6e7268ce.identity.oraclecloud.com:443/oauth2/v1/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -u "e965fde862964bfa8ac6e86b5bf04198:$OCI_CLIENT_SECRET" \
  -d "grant_type=urn:ietf:params:oauth:grant-type:token-exchange" \
  -d "subject_token=$TFC_WORKLOAD_IDENTITY_TOKEN" \
  -d "subject_token_type=urn:ietf:params:oauth:token-type:jwt" \
  -d "requested_token_type=urn:ietf:params:oauth:token-type:jwt")

# Extract the token and format it as JSON for the Terraform external data source
ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r '.access_token')
jq -n --arg token "$ACCESS_TOKEN" '{"access_token":$token}'