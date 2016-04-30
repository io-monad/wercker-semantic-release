#!/bin/bash

GH_TOKEN=${WERCKER_SEMANTIC_RELEASE_GITHUB_TOKEN:-$GH_TOKEN}
NPM_TOKEN=${WERCKER_SEMANTIC_RELEASE_NPM_TOKEN:-$NPM_TOKEN}
IGNORE_NO_RELEASE=${WERCKER_SEMANTIC_RELEASE_IGNORE_NO_RELEASE}

if [ -z "$GH_TOKEN" ]; then
  fail "Please set github_token property or \$GH_TOKEN environment variable"
fi
if [ -z "$NPM_TOKEN" ]; then
  fail "Please set npm_token property or \$NPM_TOKEN environment variable"
fi

LOG_FILE="/tmp/semantic-release.log"

GH_TOKEN="$GH_TOKEN" \
NPM_TOKEN="$NPM_TOKEN" \
CI=true \
npm run semantic-release | tee $LOG_FILE

if [ ${PIPESTATUS[0]} -eq 0 ]; then
  success "semantic-release succeeded"
else
  if [ "$IGNORE_NO_RELEASE" = "false" ]; then
    fail "semantic-release failed"
  elif [ "`grep -c ENOCHANGE $LOG_FILE`" -eq 0 ]; then
    fail "semantic-release failed with errors other than ENOCHANGE"
  else
    success "semantic-release succeeded but made no release"
  fi
fi
