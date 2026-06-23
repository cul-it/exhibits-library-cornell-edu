ARG RUBY_VERSION=3.4.9

################################################################################
# Stage for building base image
# Debian 13
FROM ruby:$RUBY_VERSION-slim-trixie AS ruby_base

# Install packages required for rails app
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev=1.1.* \
    cron=3.* \
    libghc-libyaml-dev=0.1.* \
    libvips \
    libvips-dev \
    libvips-tools \
    # Remove git once riif install is switched back to rubygems.org/ version
    git && \
    apt-get clean

################################################################################
# Node toolchain for building assets. Kept out of ruby_base so it never reaches
# the final runtime image. npm exists only to bootstrap yarn.
FROM ruby_base AS bundler_base

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    nodejs=20.19.* \
    npm=9.2.* && \
    apt-get clean && \
    npm install --global yarn@1.22.*

################################################################################
# Install additional libraries for development
FROM bundler_base AS dev_base

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    mariadb-server=1:11.8.* \
    libsqlite3-dev=3.46.*

################################################################################
# Build test environment
FROM dev_base AS test
ENV RAILS_ENV=test \
    APP_PATH=/exhibits

WORKDIR $APP_PATH
COPY . .

ENTRYPOINT [ "docker/build_test.sh" ]

################################################################################
# Build development environment
FROM dev_base AS development

ENV RAILS_ENV=development \
    APP_PATH=/exhibits \
    USER=crunner \
    GROUP=crunnergrp

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
# Can we run this clean up cron as crunner instead of root?
COPY ./cron/exhibits_cron /etc/cron.d/exhibits_cron
RUN groupadd -r $GROUP && useradd -mr -g $GROUP $USER && \
    chmod gu+rw /var/run && chmod gu+s /usr/sbin/cron && \
    crontab -u root /etc/cron.d/exhibits_cron
USER $USER

# Install application gems and node modules
WORKDIR $APP_PATH
COPY --chown=${USER}:${GROUP} Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=${USER}:${GROUP} . .

# Run the web server
EXPOSE 9292
ENTRYPOINT [ "docker/run_dev.sh" ]

################################################################################
# Bundle production/integration/staging environment
FROM bundler_base AS prod_bundler
ARG BUNDLE_WITHOUT
ARG RAILS_ENV

ENV RAILS_ENV=${RAILS_ENV} \
    RAILS_LOG_TO_STDOUT="1" \
    BUNDLE_WITHOUT=${BUNDLE_WITHOUT} \
    BUNDLE_PATH=/usr/local/bundle \
    APP_PATH=/exhibits

WORKDIR ${APP_PATH}
COPY ./Gemfile ./Gemfile.lock ./
RUN bundle config set --local with "${RAILS_ENV}" && \
    bundle config set --local without "${BUNDLE_WITHOUT}" && \
    bundle config set --local path "${BUNDLE_PATH}" && \
    bundle install && \
    gem install aws-sdk-s3 && \
    rm -rf ${BUNDLE_PATH}/cache/*.gem && \
    find ${BUNDLE_PATH}/ -name "*.c" -delete && \
    find ${BUNDLE_PATH}/ -name "*.o" -delete

COPY . .

# Precompile assets at build time so we can remove vulnerable node and npm
# packages from the runtime image
RUN bundle exec rake assets:precompile && rm .env

################################################################################
# Final image for integration/staging/production. Built FROM ruby_base (no node),
# so the vulnerable Debian node packages (handlebars via npm, node-undici,
# node-minimatch) never enter the runtime image. Precompiled assets and bundled
# gems are copied in from prod_bundler below.
FROM ruby_base
ARG RAILS_ENV=production

ENV RAILS_ENV=${RAILS_ENV} \
    BUNDLE_PATH=/usr/local/bundle \
    APP_PATH=/exhibits \
    USER=crunner \
    GROUP=crunnergrp \
    AWS_DEFAULT_REGION=us-east-1

# Remove vulnerable gems shipped by the ruby base image that are replaced by bundled gems.
RUN RG=/usr/local/lib/ruby/gems/3.4.0 && \
    rm -f "$RG"/specifications/net-imap-0.5.8.gemspec && \
    rm -rf "$RG"/gems/net-imap-0.5.8 && \
    rm -f "$RG"/specifications/default/erb-4.0.4.gemspec

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
# Can we run this clean up cron as crunner instead of root?
# Includes localtime adjustment
COPY ./cron/exhibits_cron /etc/cron.d/exhibits_cron
RUN groupadd -r $GROUP && useradd -mr -g $GROUP $USER && \
    chmod gu+rw /var/run && chmod gu+s /usr/sbin/cron && \
    crontab -u root /etc/cron.d/exhibits_cron && \
    ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime

# Copy application code from builder
COPY --from=prod_bundler --chown=${USER}:${GROUP} ${BUNDLE_PATH} ${BUNDLE_PATH}
COPY --from=prod_bundler --chown=${USER}:${GROUP} ${APP_PATH} ${APP_PATH}
RUN chown ${USER}:${GROUP} ${APP_PATH}

# Debugging tools, don't use on production
# RUN apt-get install -y --no-install-recommends vim

USER ${USER}
WORKDIR ${APP_PATH}

# Run the web server
EXPOSE 9292
ENTRYPOINT [ "docker/run.sh" ]
