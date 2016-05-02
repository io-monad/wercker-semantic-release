#!/bin/bash

GH_TOKEN=${WERCKER_SEMANTIC_RELEASE_GITHUB_TOKEN:-$GH_TOKEN}
NPM_TOKEN=${WERCKER_SEMANTIC_RELEASE_NPM_TOKEN:-$NPM_TOKEN}

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
npm run semantic-release 2>&1 | tee $LOG_FILE

if [ ${PIPESTATUS[0]} -eq 0 ]; then
  success "semantic-release succeeded"
else
  CODE=$(awk '/semantic-release ERR! pre E[A-Z0-9]+/ { print $4 }' $LOG_FILE)
  case "$CODE" in
    "ENOCHANGE" )
      success "semantic-release skipped (no change for release)";;
    "EBRANCHMISMATCH" )
      success "semantic-release skipped (not target branch)";;
    * )
      fail "semantic-release failed";;
  esac
fi
