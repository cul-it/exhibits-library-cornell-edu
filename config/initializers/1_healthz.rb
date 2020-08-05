# frozen_string_literal: true

# Add an endpoint at `/healthz` if `OkComputer` is installed.
#   - `healthz` functions as a basic liveness check;
#   - `healthz/{status_name}` checks a specific registered status;
#   - `healthz/all` compiles all registered checks.
#
# To install these checks by default, add `gem 'okcomputer'` to your
# application's `Gemfile`.
#
# @see https://github.com/sportngin/okcomputer/
begin
  # OkComputer.mount_at = 'healthz' # TODO: elr - remove this if it works

  require 'health_checks'

  # TODO: elr - evaluate which checks to include
  # OkComputer::Registry.register "version", OkComputer::AppVersionCheck.new
  # OkComputer::Registry.register "cache", OkComputer::CacheCheck.new
  # OkComputer::Registry.register "delayed_jobs", OkComputer::DelayedJobBackedUpCheck.new(10, 50)
  # OkComputer::Registry.register "solr", OkComputer::SolrCheck.new(Blacklight.default_index.connection.uri.to_s)
  # OkComputer::Registry.register 'solr', HealthChecks::SolrCheck.new # TODO: elr - remove this if it works
  OkComputer::Registry.register "solr", OkComputer::HttpCheck.new(Blacklight.default_index.connection.uri.to_s.sub(/\/$/, '') + "/admin/ping")

  # OkComputer.make_optional %w(version cache delayed_jobs)

  # check cache
  if ENV['MEMCACHED_HOST']
    OkComputer::Registry
        .register 'cache', OkComputer::CacheCheck.new(ENV.fetch('MEMCACHED_HOST'))
  else
    OkComputer::Registry.register 'cache', OkComputer::CacheCheck.new
  end
rescue NameError => err
  raise(err) unless err.message.include?('OkComputer')
  Rails.logger.info 'OkComputer not installed. ' \
                    'Skipping health endpoint at `/healthz`' \
                    'Add `gem "OkComputer"` to your Gemfile if you want to ' \
                    'install default health checks.'
end
