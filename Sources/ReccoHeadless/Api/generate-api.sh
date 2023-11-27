#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo ""
echo "#############################################"
echo "# Generating Swift clients from OpenAPI! :) #"
echo "#############################################"
echo ""

# Remove previously generated client
rm -rf ./Generated

# Generate new Swift client
if openapi-generator generate \
    -i ./sf-backend-open-api.json \
    -g swift5 \
    --model-name-suffix DTO \
    --additional-properties responseAs=AsyncAwait,nonPublicApi=true \
    --type-mappings=date-time=Date \
    --type-mappings=date=String \
    -o ./output; then
    # Move new client files to code-gen
    cp -R ./output/OpenAPIClient/Classes/OpenAPIs/ ./Generated

    # Remove output folder
    rm -rf ./output

    echo ""
    echo "#########################################"
    echo "# Swift client created successfully! :) #"
    echo "#########################################"
    echo ""
else
    echo ""
    echo "#########################################"
    echo "# Error: Swift client generation failed! #"
    echo "#########################################"
    echo ""
    exit 1
fi
