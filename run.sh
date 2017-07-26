#!/bin/sh

rm -rf node_modules/.bin
npm prune --production
npm rebuild $WERCKER_PREPARE_GASBUDDY_DEPLOY_REBUILD
rm -rf ~/.npmrc src tests coverage .nyc_output /pipeline/cache config/development.json
