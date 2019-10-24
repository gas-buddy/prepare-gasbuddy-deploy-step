#!/bin/sh

export NODE_ENV=production
export AWS_ECR_TAG=$(cat WERCKER_BUILD_ID)_$WERCKER_GIT_COMMIT

rm -rf node_modules/.bin
npm prune --production
npm rebuild $WERCKER_PREPARE_GASBUDDY_DEPLOY_REBUILD
rm -rf ~/.npmrc src tests coverage .nyc_output /pipeline/cache config/development.json .git

# Rebuild stupid bcrypt
if npm ls bcrypt &>/dev/null; then
  apk -q --no-progress --no-cache --virtual .bcryptdeps add make gcc g++ python
  npm i -g node-pre-gyp
  npm rebuild bcrypt --build-from-source=bcrypt
  npm rm -g node-pre-gyp
  apk -q --no-progress --no-cache del .bcryptdeps
fi

# Rebuild stupid grpc
if npm ls grpc &>/dev/null; then
  npm rebuild grpc --update-binary
fi
