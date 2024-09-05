#!/usr/bin/env ruby

# frozen_string_literal: true

require 'aws-sdk-s3'

PROD = "production"
STAGING = "staging"
DEV = "development"
INTEGRATION = "integration"
environment = ARGV.shift || DEV
workdir = ARGV.shift || "/exhibits"
env = ""
if PROD.casecmp(environment) == 0
    env = "prod"
elsif STAGING.casecmp(environment) == 0
    env = "staging"
# elsif DEV.casecmp(environment)
#     env = "dev"
elsif INTEGRATION.casecmp(environment) == 0
    env = "int"
else
    env = "dev"
end
BUCKET = 'exhibits-container'
ENV_KEY = "exhibits-#{env}.env"

client = Aws::S3::Client.new(region: 'us-east-1')
target = "#{workdir}/.env"
client.get_object({ bucket: BUCKET, key: ENV_KEY }, target:)
