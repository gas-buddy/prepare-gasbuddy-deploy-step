#!/bin/sh

export NODE_ENV=production
export AWS_ECR_TAG=$(cat WERCKER_BUILD_ID)_$WERCKER_GIT_COMMIT

rm -rf node_modules/.bin
npm prune --production
npm rebuild "$WERCKER_PREPARE_GASBUDDY_DEPLOY_REBUILD"
rm -rf ~/.npmrc src tests coverage .nyc_output /pipeline/cache config/development.json .git

if npm ls bcrypt sharp grpc >/dev/null 2>&1; then
  apk -q --no-progress --no-cache --virtual .nativedeps add make gcc g++ python
  npm i -g node-pre-gyp
  # Rebuild stupid bcrypt
  if npm ls bcrypt >/dev/null 2>&1; then
    npm rebuild bcrypt --build-from-source=bcrypt
  fi
  # Rebuild stupid sharp
  if npm ls sharp >/dev/null 2>&1; then
    rm -rf node_modules/sharp/vendor
    npm rebuild sharp
  fi
  # Rebuild stupid grpc
  if npm ls grpc >/dev/null 2>&1; then
    npm rebuild grpc --update-binary
  fi
  npm rm -g node-pre-gyp
  apk -q --no-progress --no-cache del .nativedeps
fi