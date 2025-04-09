ARG RUBY_VERSION=3.2.2

################################################################################
# Stage for building base image
# Debian 12
# Includes high vulnerability:
#    GnuTLS - https://scout.docker.com/vulnerabilities/id/CVE-2024-0567
#    Check container-discovery for examples of patching CVEs
FROM ruby:$RUBY_VERSION-slim-bookworm as ruby_base

# Install packages required for rails app
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev=1.1.0 \
    cron=3.0pl1-162 \
    nodejs=18.19.0+dfsg-6~deb12u2 \
    npm=9.2.0~ds1-1 \
    imagemagick=8:6.9.11.60+dfsg-1.6+deb12u1

RUN npm install --global yarn@1.22.22

################################################################################
# Install additional libraries for development
FROM ruby_base as dev_base

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    mariadb-server \
    libsqlite3-dev=3.40.1-2+deb12u1

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
RUN groupadd -r $GROUP && useradd -mr -g $GROUP $USER
USER $USER

# Install application gems and node modules
WORKDIR $APP_PATH
COPY --chown=${USER}:${GROUP} Gemfile Gemfile.lock ./
RUN bundle install
RUN yarn install

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

# Can we run this clean up cron as crunner instead of root?
# exhibits_cron - .ebextentions/tmp_cleanup.config
# localtime adjustment - .ebextentions/system_time.config
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

# Run the web server
EXPOSE 9292
ENTRYPOINT [ "docker/run.sh" ]
