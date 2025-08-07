#!/bin/bash

# URL for Pikachu's data
POKEAPI_URL="https://pokeapi.co/api/v2/pokemon/25/"

# Output files
DATA_FILE="data.json"
ERROR_FILE="errors.txt"

# Make API request using curl and handle response
curl -s -o "$DATA_FILE" "$POKEAPI_URL" -w "%{http_code}" | {
  read http_code
  if [ "$http_code" -ne 200 ]; then
    echo "Error: API request failed with status code $http_code" >> "$ERROR_FILE"
    exit 1
  fi
}

# Check if data.json was created and is not empty
if [ ! -s "$DATA_FILE" ]; then
  echo "Error: Failed to retrieve or save data" >> "$ERROR_FILE"
  exit 1
fi

# Optionally, verify the JSON content using jq
if ! jq . "$DATA_FILE" >/dev/null 2>>"$ERROR_FILE"; then
  echo "Error: Invalid JSON response" >> "$ERROR_FILE"
  exit 1
fi
