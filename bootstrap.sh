#!/bin/bash 
set -euo pipefail

fail() {
  echo FAIL: "$@"
  exit 1
}

SECRETS=$(echo $VCAP_SERVICES | jq -r '.["user-provided"][] | select(.name == "secrets") | .credentials') ||
  fail "Unable to parse SECRETS from VCAP_SERVICES"

DB_NAME=$(echo $VCAP_SERVICES | jq -r '.["aws-rds"][] | .credentials.db_name')
DB_USER=$(echo $VCAP_SERVICES | jq -r '.["aws-rds"][] | .credentials.username')
DB_PASSWORD=$(echo $VCAP_SERVICES | jq -r '.["aws-rds"][] | .credentials.password')
DB_HOST=$(echo $VCAP_SERVICES | jq -r '.["aws-rds"][] | .credentials.host')
DB_PORT=$(echo $VCAP_SERVICES | jq -r '.["aws-rds"][] | .credentials.port')

ENCRYPTION_KEY=$(echo $SECRETS | jq -r '.ENCRYPTION_KEY')

:>.env
for e in DB_NAME DB_USER DB_PASSWORD DB_HOST DB_PASSWORD ENCRYPTION_KEY; do 
  echo "$e: ${!e}" >> .env
done 

exit 
#APP_NAME=$(echo $VCAP_APPLICATION | jq -r '.name') ||
#  fail "Unable to parse APP_NAME from VCAP_SERVICES"
#APP_ROOT=$(dirname "${BASH_SOURCE[0]}")
##APP_ID=$(echo "$VCAP_APPLICATION" | jq -r '.application_id')