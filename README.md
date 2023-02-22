# CUL Online Exhibitions

### Prerequisites

* ruby
* bundler
* Docker (to start with Docker)

### QuickStart

#### OPTION 1: Start with Docker (EXPERIMENTAL)

```sh
$ docker-compose build
$ docker-compose up -d
```

Access through browser: http://localhost:3000

Run tests:
```sh
$ docker-compose run -e "RAILS_ENV=test" app bundle exec rspec
```

#### OPTION 2: Start app manually

1. Clone this repo
   ```sh
   $ git clone git@github.com:cul-it/exhibits-library-cornell-edu.git
   ```

1. Install gems
   ```sh
   $ cd <clone>
   $ bundle install
   ```

1. Run database migrations
   ```sh
   $ bin/rake db:migrate
   ```

1. Copy example dotenv file
   ```sh
   $ cp .env.example .env
   ```

1. Start Solr (via [solr_wrapper](https://github.com/cbeer/solr_wrapper))
   ```sh
   $ bin/solr_wrapper
   ```
   > Solr will be accessible at http://localhost:8983/solr
   >
   > solr_wrapper is configured to persist data between runs. Please refer to the [solr_wrapper documentation](https://github.com/cbeer/solr_wrapper#cleaning-your-repository-from-the-command-line) for details on purging persisted data.

1. Create an initial admin user and default exhibit
   ```sh
   $ bin/rake spotlight:initialize
   ```

1. Start Sidekiq for processing background jobs (Needs to run at the root of the rails app.)
   ```sh
   $ bundle exec sidekiq -d -L log/sidekiq.log -e development
   ```

1. Start Rails in new terminal session
   ```sh
   $ rails s
   ```
   > Visit the application at  [http://localhost:3000](http://localhost:3000)

### Linting/Testing

1. RuboCop

   > Ensure consistency in code style/formatting

   ```sh
   bin/rubocop
   ```
### Circle/CI
Go to https://circleci.com and pick "log in" and the "Login with GitHub" option.  This will allow you to select this repository.  Once you are logged in, you should be able to see CircleCI builds and messages.   

Trivial change to test autodeploy of dev branch.