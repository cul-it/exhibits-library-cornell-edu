#!/usr/bin/env ruby

# frozen_string_literal: true

require 'aws-sdk-s3'

environment = ARGV.shift || 'development'
workdir = ARGV.shift || '/exhibits'

env_map = {
  'production' => 'prod',
  'staging' => 'staging',
  'integration' => 'int',
  'development' => 'dev'
}
env = env_map[environment.downcase] || 'dev'

BUCKET = 'exhibits-container'
ENV_KEY = "exhibits-#{env}.env"
TARGET = "#{workdir}/.env"

client = Aws::S3::Client.new(region: 'us-east-1')
client.get_object({ bucket: BUCKET, key: ENV_KEY }, target: TARGET)
