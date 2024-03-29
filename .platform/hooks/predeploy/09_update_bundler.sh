#!/usr/bin/env bash

# WARNING: This file lives under `.platform/hooks/predeploy` and `.platform/confighooks/predeploy`.
#   Any changes made to this file should also be made to the other file with the same name.

UPDATE_BUNDLER=$(/opt/elasticbeanstalk/bin/get-config environment -k UPDATE_BUNDLER)

echo '***** Checking if bundler should be updated'
if [ $UPDATE_BUNDLER = true ] ; then
  # @example $CMD = /opt/rubies/ruby-3.0.5/bin/gem install bundler -v 2.4.8
  # Where environment variables values are...
  #   $RUBY_PATH = '/opt/rubies/ruby-3.0.5/bin/gem'
  #   $BUNDLER_VERSION = '2.4.8'

  RUBY_PATH=$(/opt/elasticbeanstalk/bin/get-config environment -k RUBY_PATH)
  BUNDLER_VERSION=$(/opt/elasticbeanstalk/bin/get-config environment -k BUNDLER_VERSION)

  CMD="$RUBY_PATH install bundler -v $BUNDLER_VERSION"
  echo "***** Executing CMD: $CMD"
  eval $CMD
fi
