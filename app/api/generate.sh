# Remove old files avoiding accumulation of outdated files
rm -rf ./generated/

# Generate new files based on doc/server/api_game/api.yaml
docker run --rm \
           -v "${PWD}":/local \
           -v "${PWD}"/../../doc/server/api_game/api.yaml:/spec/api.yaml \
           openapitools/openapi-generator-cli generate -i /spec/api.yaml -g dart \
              -o /local/generated -c /local/config.json