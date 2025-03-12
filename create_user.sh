#!/bin/bash

## This script is used to create a user on the identityhub. the resulting client secret is returned by the script.
## The desired client id must be passed as first argument to the script.

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <clientId>"
    exit 1
fi

clientId=$1

# Create user on IdentityHub
clientResponse=$(curl -sL 'http://localhost:7082/api/identity/v1alpha/participants/' \
--header 'Content-Type: application/json' \
--header 'x-api-key: c3VwZXItdXNlcg==.c3VwZXItc2VjcmV0LWtleQo=' \
--data "{
    \"roles\": [\"admin\"],
    \"serviceEndpoints\": [],
    \"active\": true,
    \"participantId\": \"${clientId}\",
    \"did\": \"$clientId\",
    \"key\": {
        \"keyId\": \"key-1\",
        \"privateKeyAlias\": \"consumer-user-alias\",
        \"keyGeneratorParams\": {
            \"algorithm\": \"EdDSA\",
            \"curve\": \"Ed25519\"
        }
    }
}")

echo $clientResponse | jq -r '.clientSecret'