# frozen_string_literal: true

# Endpoint for okcomputer is `/syscheck`
#   - `syscheck` functions as a basic liveness check that the app responds;
#   - `syscheck/{status_name}` checks a specific registered status (e.g. `syscheck/solr`);
#   - `syscheck/all` compiles all registered checks.
#
# @see https://github.com/sportngin/okcomputer/

OkComputer.mount_at = false # when false, expects mount to happen in routes

require 'health_checks'

OkComputer::Registry.register "version", OkComputer::AppVersionCheck.new
OkComputer::Registry.register "cache", OkComputer::CacheCheck.new
OkComputer::Registry.register "sidekiq", OkComputer::SidekiqLatencyCheck.new('default', 50)
OkComputer::Registry.register "solr", OkComputer::HttpCheck.new(Blacklight.default_index.connection.uri.to_s.sub(/\/$/, '') + "/admin/ping")

# do not fail syschecks pageload if any of the following checks fail; results will be displayed
OkComputer.make_optional %w(version cache sidekiq)
