#!/bin/bash

JWT_PART=$1
PADDING=$(( (4 - ${#JWT_PART} % 4) % 4 ))
# add padding and decode payload
payload=$(echo "$JWT_PART$(printf '%0.s=' $(seq 1 $PADDING))" | tr '_-' '/+' | base64 --decode)

echo $payload