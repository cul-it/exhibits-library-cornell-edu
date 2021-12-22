#!/usr/bin/env bash
# ref: https://forums.aws.amazon.com/thread.jspa?threadID=330819

# WARNING: This file lives under `.platform/hooks/postdeploy` and `.platform/confighooks/postdeploy`.
#   Any changes made to this file should also be made to the other file with the same name.

EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppUser)
EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)
EB_APP_PID_DIR="/var/pids"
EB_SUPPORT_DIR="/opt/elasticbeanstalk/support"

SIDEKIQ_PID=$EB_APP_PID_DIR/sidekiq.pid
SIDEKIQ_CONFIG=$EB_APP_DEPLOY_DIR/config/sidekiq.yml
SIDEKIQ_LOG=$EB_APP_DEPLOY_DIR/log/sidekiq.log

RACK_ENV=$(/opt/elasticbeanstalk/bin/get-config environment -k RACK_ENV)

cd $EB_APP_DEPLOY_DIR

if [ -f $SIDEKIQ_PID ]; then
  echo "terminating existing sidekiq"
  su -s /bin/bash -c "kill -TERM `cat $SIDEKIQ_PID`" $EB_APP_USER
  su -s /bin/bash -c "rm -rf $SIDEKIQ_PID" $EB_APP_USER
fi

sleep 10

set -xe
export $(cat /opt/elasticbeanstalk/deployment/env | xargs)

echo "starting sidekiq"
su -s /bin/bash -c "bundle exec sidekiq \
-e $RACK_ENV \
-P $SIDEKIQ_PID \
-C $SIDEKIQ_CONFIG \
-L $SIDEKIQ_LOG \
-d" $EB_APP_USER
