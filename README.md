# CUL Online Exhibitions

## Prerequisites

* [Ruby 3.0.5](https://www.ruby-lang.org/en/documentation/installation/)
* [Bundler 2](https://bundler.io/)
* [ImageMagick](https://imagemagick.org/script/download.php)
* [Solr](https://solr.apache.org/guide/solr/latest/deployment-guide/installing-solr.html)
* Optional: [Docker](https://docs.docker.com/get-docker/)

## QuickStart

### OPTION 1: Start with Docker

```
$ docker compose -f compose.dev.yaml up
```

Web server: http://localhost:9292
Solr: http://localhost:8983

Run full test suite:
```
$ ./docker/run_test.sh
```

Open the test container in interactive mode and run tests individually:

```
$ ./docker/run_test.sh -i
$ bundle exec rspec spec/models/solr_document_spec.rb:20
```

### OPTION 2: Start app manually

1. Clone this repo
   ```sh
   $ git clone git@github.com:cul-it/exhibits-library-cornell-edu.git
   ```

1. Install gems
   ```sh
   $ cd <clone>
   $ bundle install
   ```

1. Copy example dotenv file and update `CHANGEME` values
   ```sh
   $ cp .env.example .env
   ```

1. Create the database and run migrations
   ```sh
   $ bin/rake db:create db:schema:load db:migrate
   ```

1. Start Solr (via [solr_wrapper](https://github.com/cbeer/solr_wrapper))
   ```sh
   $ bin/solr_wrapper
   ```
   > Solr will be accessible at http://localhost:8983/solr
   >
   > solr_wrapper is configured to persist data between runs. Please refer to the [solr_wrapper documentation](https://github.com/cbeer/solr_wrapper#cleaning-your-repository-from-the-command-line) for details on purging persisted data.
   >
   > Additional configurations can be made in [.solr_wrapper.yml](.solr_wrapper.yml)

1. Create an initial admin user and default exhibit
   ```sh
   $ bin/rake spotlight:initialize
   ```

1. Start Redis and Sidekiq for processing background jobs (Needs to run at the root of the rails app.)
   ```sh
   $ redis-server
   $ bundle exec sidekiq
   ```

1. Start Rails in new terminal session
   ```sh
   $ rails s
   ```
   > Visit the application at [http://localhost:3000](http://localhost:3000)
   >
   > Visit the Sidekiq dashboard at [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)

## Linting

This project uses RuboCop to ensure consistency in code style/formatting.

To output rubocop issues with docker:

```
# Open an interactive bash session:
$ docker compose -f compose.dev.yaml exec -it webapp bash

# Run rubocop:
$ bundle exec rubocop
```

To output rubocop issues with manual setup:

```
$ bundle exec rubocop
```

## Circle/CI
Go to https://circleci.com and pick "log in" and the "Login with GitHub" option.  This will allow you to select this repository.  Once you are logged in, you should be able to see CircleCI builds and messages.   
