#!/bin/bash

clientSecret=$1
# Request ID token from STS 
idToken=$(curl -sL 'http://localhost:7086/api/sts/token' \
--header 'Content-Type: application/x-www-form-urlencoded' \
--data-urlencode "client_id=did:web:localhost%3A7083" \
--data-urlencode "client_secret=${clientSecret}" \
--data-urlencode "grant_type=client_credentials" \
--data-urlencode "bearer_access_scope=org.eclipse.edc.vc.type:MembershipCredential:read" \
--data-urlencode "audience=did:web:localhost%3A7083" | jq -r '.access_token')

# Extract "token" claim from ID token
# we need to potentially fix padding. For that, we are only interested in the payload part of the token:
JWT_PART=$(echo $idToken | cut -d "." -f2) 
# calculate padding:
payload=$(./decode.sh $JWT_PART)

# the access token is wrapped in the ID token in the "token" claim
accessToken=$(echo $payload | jq -r '.token')

echo $accessToken