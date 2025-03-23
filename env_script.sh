#!/bin/bash

# Check if the first argument is passed
if [ -z "$1" ]; then
  echo "Error: specify the path to the JSON file."
  echo "Usage: $0 <path_to_JSON_file> "
  exit 1
fi

# Read the JSON file and encode it in Base64
ENCODED_JSON=$(cat "$1" | base64 -w 0)

# Write to the .env file
echo "TF_VAR_gcp_creds=${ENCODED_JSON}" > .env

echo ".env file successfully created."