#!/bin/bash

echo ""
echo "#############################################"
echo "# Generating Swift clients from OpenAPI! :) #"
echo "#############################################"
echo ""

# Remove previously generated client
rm -rf ./Generated

# Generate new Swift client
openapi-generator generate \
	-i ./sf-backend-open-api.json \
	-g swift5 \
	--model-name-suffix DTO \
    --additional-properties responseAs=AsyncAwait,nonPublicApi=true \
    --type-mappings=date-time=Date \
    --type-mappings=date=String \
	-o ./output


# Move new client files to code-gen
cp -R ./output/OpenAPIClient/Classes/OpenAPIs/ ./Generated

# Remove output folder
rm -rf ./output

echo "\nPatching APIHelper.swift file...to handle rawRepresentable enums in path"
echo "-> Patching APIHelper.swift extension..."

./patch-api

echo ""
echo "#########################################"
echo "# Swift client created successfully! :) #"
echo "#########################################"
echo ""
