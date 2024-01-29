#!/usr/bin/env bash

set +e # Do not fail on error
node -p "require('./package.json').scripts.test" &> /dev/null
exitCode=$?
set -e # Fail on error

# No tests, build package instead as a basic test and to publish it
if ! $exitCode ; then
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
