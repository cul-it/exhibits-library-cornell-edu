ARG RUBY_VERSION=3.0.5

################################################################################
# Stage for building base image
# Debian 11
# Includes critical vulnerability:
#    cgi 0.2.2 - https://scout.docker.com/vulnerabilities/id/CVE-2021-41816
#    Check container-discovery for examples of patching CVEs
# Should upgrade to latest Debian when ruby is upgraded
FROM ruby:$RUBY_VERSION-slim-bullseye as ruby_base

RUN apt-get update -qq && apt-get install -y build-essential

# Install other packages required for rails app
# Only install chrome in test?
RUN apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev=1.0.7 \
    mariadb-server \
    libsqlite3-dev \
    nodejs \
    imagemagick

################################################################################
# Build test environment
FROM ruby_base as test
ENV RAILS_ENV=test \
    APP_PATH=/exhibits

# Install application gems
WORKDIR $APP_PATH
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENTRYPOINT [ "docker/build_test.sh" ]

################################################################################
# Build development environment
FROM ruby_base as development

ENV RAILS_ENV=development \
    APP_PATH=/exhibits \
    USER=crunner \
    GROUP=crunnergrp

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
RUN groupadd -r $GROUP && useradd -r -g $GROUP $USER && \
    mkdir -p /home/${USER} && \
    chown ${USER}:${GROUP} /home/${USER}
USER $USER

# Install application gems
WORKDIR $APP_PATH
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY --chown=${USER}:${GROUP} . .

# Run the web server
EXPOSE 9292
ENTRYPOINT [ "docker/puma.sh" ]
