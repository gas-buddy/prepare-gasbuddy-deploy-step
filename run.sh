#!/bin/sh

export NODE_ENV=production
export AWS_ECR_TAG=$(cat WERCKER_BUILD_ID)_$WERCKER_GIT_COMMIT

rm -rf node_modules/.bin
npm prune --production
npm rebuild $WERCKER_PREPARE_GASBUDDY_DEPLOY_REBUILD
rm -rf ~/.npmrc src tests coverage .nyc_output /pipeline/cache config/development.json .git
