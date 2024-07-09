docker run --rm \
           -v "${PWD}":/local \
           -v "${PWD}"/../../doc/api:/spec \
           openapitools/openapi-generator-cli generate -i /spec/api.yaml -g dart \
           -o /local/generated -c /local/config.json