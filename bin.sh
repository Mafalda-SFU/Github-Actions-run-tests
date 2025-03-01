#!/usr/bin/env bash

test_length=$(jq -r '.scripts.test | length' package.json)

# No tests, build package instead as a basic test and to publish it
if [ $test_length -eq 0 ]; then
  npm run build

# Jest test runner
elif npm list jest >/dev/null 2>&1; then
  npm install --no-save --verbose \
    @matteoh2o1999/github-actions-jest-reporter

  npm test -- \
    --reporters=@matteoh2o1999/github-actions-jest-reporter

# Node.js built-in test runner
else
  npm install --no-save --verbose \
    node-test-github-reporter

  NODE_OPTIONS=`echo "
    --test-reporter=spec
      --test-reporter-destination=stdout
    --test-reporter=node-test-github-reporter
      --test-reporter-destination=stderr
  " | tr -d '\r\n'` \
    npm test
fi
