ARG RUBY_VERSION=3.4.8

################################################################################
# Stage for building base image
# Debian 13
FROM ruby:$RUBY_VERSION-slim-trixie as ruby_base

# Install packages required for rails app
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev=1.1.* \
    cron=3.* \
    nodejs=20.19.* \
    npm=9.2.* \
    imagemagick=8:7.1.1.* \
    libghc-libyaml-dev=0.1.*

RUN npm install --global yarn@1.22.*

################################################################################
# Install additional libraries for development
FROM ruby_base as dev_base

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    mariadb-server=1:11.8.* \
    libsqlite3-dev=3.46.*

################################################################################
# Build test environment
FROM dev_base as test
ENV RAILS_ENV=test \
    APP_PATH=/exhibits

WORKDIR $APP_PATH
COPY . .

ENTRYPOINT [ "docker/build_test.sh" ]

################################################################################
# Build development environment
FROM dev_base as development

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
FROM ruby_base as prod_bundler
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
RUN rm .env

################################################################################
# Final image for integration/staging/production
FROM prod_bundler
ARG RAILS_ENV=production

ENV RAILS_ENV=${RAILS_ENV} \
    APP_PATH=/exhibits \
    USER=crunner \
    GROUP=crunnergrp \
    AWS_DEFAULT_REGION=us-east-1

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

# Debugging tools, don't use on production use
# RUN apt-get install -y --no-install-recommends vim

USER ${USER}
WORKDIR ${APP_PATH}

# Copy imagemagick security policy
COPY ./docker/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xml

# Run the web server
EXPOSE 9292
ENTRYPOINT [ "docker/run.sh" ]
