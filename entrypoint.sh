#!/usr/bin/env bash
set -e

if [[ "$SKIP_IMPORT" != true ]]; then
    /opt/keycloak/bin/kc.sh import --file /app/misarch/template/keycloak-realm-template.json
fi

exec /opt/keycloak/bin/kc.sh "$@"
