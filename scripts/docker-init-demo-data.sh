#!/bin/sh
set -e

template_file=/opt/datacenter-mgmt/generated-mock-migration.sql
schema_placeholder=__DCIM_TARGET_SCHEMA__

case "${PGSCHEMA:-}" in
  ''|[0-9]*|*[!A-Za-z0-9_]*)
    echo "Invalid or missing PGSCHEMA: ${PGSCHEMA:-}" >&2
    exit 1
    ;;
esac

if ! grep -q "$schema_placeholder" "$template_file"; then
  echo "Schema placeholder not found in $template_file; refresh the demo data SQL first" >&2
  exit 1
fi

sed "s/$schema_placeholder/$PGSCHEMA/g" "$template_file" |
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"
