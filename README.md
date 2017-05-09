# CUL Online Exhibitions

### Prerequisites

* ruby
* bundler

### QuickStart

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
   $ rake db:migrate
   ```

1. Copy example dotenv file
   ```sh
   $ cp .env.example .env
   ```

1. Start Solr (via [solr_wrapper](https://github.com/cbeer/solr_wrapper))
   ```sh
   $ bundle exec solr_wrapper
   ```
   > Solr will be accessible at http://localhost:8983/solr
   >
   > solr_wrapper is configured to persist data between runs. Please refer to the [solr_wrapper documentation](https://github.com/cbeer/solr_wrapper#cleaning-your-repository-from-the-command-line) for details on purging persisted data.

1. Create an initial admin user and default exhibit
   ```sh
   $ rake spotlight:initialize
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
   bundle exec rubocop
   ```
