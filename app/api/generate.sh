docker run --rm \
           -v "${PWD}":/local \
           -v "${PWD}"/../../doc/server/api_game/api.yaml:/spec/api.yaml \
           openapitools/openapi-generator-cli generate -i /spec/api.yaml -g dart \
              -o /local/generated -c /local/config.json