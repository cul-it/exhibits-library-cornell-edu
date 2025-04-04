#!/usr/bin/env bash

# Writes cron jobs to crontab defined in rails app via whenever gem

EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppDeployDir)
EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config platformconfig -k AppUser)
RACK_ENV=$(/opt/elasticbeanstalk/bin/get-config environment -k RACK_ENV)

cd $EB_APP_DEPLOY_DIR

set -xe
export $(cat /opt/elasticbeanstalk/deployment/env | xargs)

echo "Setting up cron jobs via rails app"
su -s /bin/bash -c "bundle exec whenever --update-crontab --user $EB_APP_USER --set 'environment=$RACK_ENV'"
