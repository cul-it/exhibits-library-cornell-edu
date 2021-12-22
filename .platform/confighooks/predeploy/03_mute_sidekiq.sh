#!/usr/bin/env bash
# ref: https://forums.aws.amazon.com/thread.jspa?threadID=330819

# WARNING: This file is the same as `.platform/hooks/predeploy/03_mute_sidekiq.sh`.
#   Any changes made to this file should also be made to the file under `.platform/hooks`.

EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppUser)
EB_APP_PID_DIR="/var/pids"

SIDEKIQ_PID=$EB_APP_PID_DIR/sidekiq.pid
if [ -f $SIDEKIQ_PID ]; then
  echo "TERM/quieting sidekiq"
  su -s /bin/bash -c "kill -TERM `cat $SIDEKIQ_PID`" $EB_APP_USER
  su -s /bin/bash -c "rm -rf $SIDEKIQ_PID" $EB_APP_USER
fi
