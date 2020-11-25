ARG RUBY_VERSION=2.5.8
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

RUN gem install bundler:2.1.4

ENV PATH="/app/cul-it/exhibits-webapp:$PATH"
ENV RAILS_ROOT="/app/cul-it/exhibits-webapp"

COPY Gemfile Gemfile.lock ./
RUN gem update --system
RUN bundle install

COPY . .
RUN mkdir -p /app/cul-it/exhibits-webapp/log
RUN echo "" > /app/cul-it/exhibits-webapp/log/debug.log
RUN chmod 666 /app/cul-it/exhibits-webapp/log/debug.log

#RUN bundle exec rake assets:precompile

ENV PATH=./bin:$PATH

EXPOSE 3000

## Script runs when container first starts
ENTRYPOINT [ "bin/docker-entrypoint.sh" ]
CMD ["bundle", "exec", "puma", "-v", "-b", "tcp://0.0.0.0:3000"]

# Run tests in terminal:
# ```
#   $ docker-compose build
#   $ docker-compose up -d
#   $ docker-compose exec -w app /app/cul-it/exhibits-webapp sh -c "bundle exec rspec"
# ```
