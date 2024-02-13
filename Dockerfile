ARG RUBY_VERSION=3.2.2

################################################################################
# Stage for building base image
# Debian 12
# Includes high vulnerability:
#    GnuTLS - https://scout.docker.com/vulnerabilities/id/CVE-2024-0567
#    Check container-discovery for examples of patching CVEs
FROM ruby:$RUBY_VERSION-slim-bookworm as ruby_base

RUN apt-get update -qq && apt-get install -y build-essential

# Install other packages required for rails app
RUN apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev=1.1.0 \
    mariadb-server \
    libsqlite3-dev \
    nodejs \
    imagemagick ghostscript

# Update ImageMagick policy to allow PDFs
ARG IMAGEMAGICK_POLICY=/etc/ImageMagick-6/policy.xml
RUN if [ -f $IMAGEMAGICK_POLICY ] ; then sed -i 's/<policy domain="coder" rights="none" pattern="PDF" \/>/<policy domain="coder" rights="read|write" pattern="PDF" \/>/g' $IMAGEMAGICK_POLICY ; else echo did not see file $IMAGEMAGICK_POLICY ; fi

################################################################################
# Build test environment
FROM ruby_base as test
ENV RAILS_ENV=test \
    APP_PATH=/exhibits

# Copy application code
WORKDIR $APP_PATH
COPY . .

# Install application gems
RUN bundle install

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

# Copy application code
WORKDIR $APP_PATH
COPY --chown=${USER}:${GROUP} . .

# Install application gems
RUN bundle install

# Run the web server
EXPOSE 9292
ENTRYPOINT [ "docker/puma.sh" ]
