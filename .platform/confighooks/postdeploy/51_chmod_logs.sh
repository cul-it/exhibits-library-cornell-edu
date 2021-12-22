#!/usr/bin/env bash

# WARNING: This file is the same as `.platform/hooks/postdeploy/51_chmod_logs.sh`.
#   Any changes made to this file should also be made to the file under `.platform/hooks`.

EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)
APP_LOG_DIR=$EB_APP_DEPLOY_DIR/log
SIDEKIQ_LOG=$APP_LOG_DIR/sidekiq.log
DEBUG_LOG=$APP_LOG_DIR/debug.log

RACK_ENV=$(/opt/elasticbeanstalk/bin/get-config environment -k RACK_ENV)

case $RACK_ENV in
"integration")
  RAILS_LOG=$APP_LOG_DIR/integration.log
  ;;
"staging")
  RAILS_LOG=$APP_LOG_DIR/staging.log
  ;;
"production")
  RAILS_LOG=$APP_LOG_DIR/production.log
  ;;
esac

touch $SIDEKIQ_LOG
chmod 0664 $SIDEKIQ_LOG
touch $RAILS_LOG
chmod 0664 $RAILS_LOG

# The app should be able to write with permissions set to 0664, but it can't at this point.  See Issue #330.
touch $DEBUG_LOG
chmod 0666 $DEBUG_LOG
