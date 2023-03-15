ARG RUBY_VERSION=3.1.3
FROM ruby:$RUBY_VERSION-alpine

## Install dependencies:
## - build-base: To ensure certain gems can be compiled
## - git: Allow bundler to fetch and install ruby gems
## - nodejs: Required by Rails
## - sqlite-dev: For running tests in the container
## - tzdata: add time zone support
## - mariadb-dev: To allow use of MySQL gem
## - imagemagick: for image processing
RUN apk add --update --no-cache \
      bash \
      build-base \
      git \
      nodejs \
      sqlite-dev \
      tzdata \
      mariadb-dev \
      imagemagick6-dev imagemagick6-libs


WORKDIR /app/cul-it/exhibits-webapp

RUN gem install bundler:2.4.8

ENV PATH="/app/cul-it/exhibits-webapp:$PATH"
ENV RAILS_ROOT="/app/cul-it/exhibits-webapp"

COPY Gemfile Gemfile.lock ./
RUN gem update --system
RUN bundle install

COPY . .
RUN mkdir -p /app/cul-it/exhibits-webapp/log
RUN echo "" > /app/cul-it/exhibits-webapp/log/debug.log
RUN chmod 666 /app/cul-it/exhibits-webapp/log/debug.log
RUN echo "" > /app/cul-it/exhibits-webapp/log/sidekiq.log
RUN chmod 666 /app/cul-it/exhibits-webapp/log/sidekiq.log

#RUN bundle exec rake assets:precompile

ENV PATH=./bin:$PATH

EXPOSE 3000

## Script runs when container first starts
ENTRYPOINT [ "bin/docker-entrypoint.sh" ]
CMD ["bundle", "exec", "puma", "-v", "-b", "tcp://0.0.0.0:3000"]
