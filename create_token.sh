#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <accessToken>"
    exit 1
fi

accessToken=$1

# use the existing ID token template and replace the "token" claim with the access token
idToken=$(cat id_token_template.json | jq '.token=$accessToken' --arg accessToken $accessToken)

echo $idToken 