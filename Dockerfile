ARG RUBY_VERSION=3.0.5

# Debian 11
# Includes critical vulnerability:
#    cgi 0.2.2 - https://scout.docker.com/vulnerabilities/id/CVE-2021-41816
#    Check container-discovery for examples of patching CVEs
# Should upgrade to latest Debian when ruby is upgraded
FROM ruby:$RUBY_VERSION-slim-bullseye as ruby_base

RUN apt-get update -qq && apt-get install -y build-essential

# Install other packages required for rails app
# Only install chrome in test?
# Do I really need netcat? Right now, just used in db-wait.sh
RUN apt-get install -y --no-install-recommends \
    default-libmysqlclient-dev=1.0.7 \
    netcat \
    mariadb-server \
    libsqlite3-dev \
    nodejs \
    imagemagick

# Separate stages for different rails envs
ENV RAILS_ENV=development \
    APP_PATH=/webapp

# Install application gems
WORKDIR $APP_PATH
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

# Script runs when container first starts
ENTRYPOINT [ "bin/docker-entrypoint.sh" ]

# Start webapp server
RUN mkdir -p ./tmp/pids
CMD ["bundle", "exec", "puma", "-v", "-b", "tcp://0.0.0.0:3000"]

# ################################################################################
# # Create a stage for building/compiling the application.
# #
# # The following commands will leverage the "base" stage above to generate
# # a "hello world" script and make it executable, but for a real application, you
# # would issue a RUN command for your application's build process to generate the
# # executable. For language-specific examples, take a look at the Dockerfiles in
# # the Awesome Compose repository: https://github.com/docker/awesome-compose
# FROM ruby_base as build
# COPY <<EOF /bin/hello.sh
# #!/bin/sh
# echo Hello world from $(whoami)! In order to get your application running in a container, take a look at the comments in the Dockerfile to get started.
# EOF
# RUN chmod +x /bin/hello.sh

# ################################################################################
# # Create a final stage for running your application.
# #
# # The following commands copy the output from the "build" stage above and tell
# # the container runtime to execute it when the image is run. Ideally this stage
# # contains the minimal runtime dependencies for the application as to produce
# # the smallest image possible. This often means using a different and smaller
# # image than the one used for building the application, but for illustrative
# # purposes the "base" image is used here.
# FROM ruby_base AS final

# # Create a non-privileged user that the app will run under.
# # See https://docs.docker.com/go/dockerfile-user-best-practices/
# ARG UID=10001
# RUN adduser \
#     --disabled-password \
#     --gecos "" \
#     --home "/nonexistent" \
#     --shell "/sbin/nologin" \
#     --no-create-home \
#     --uid "${UID}" \
#     appuser
# USER appuser

# # Copy the executable from the "build" stage.
# COPY --from=build /bin/hello.sh /bin/

# # What the container should run when it is started.
# ENTRYPOINT [ "/bin/hello.sh" ]
