# CUL Online Exhibitions

### Prerequisites

* ruby
* bundler

### QuickStart

1. Clone this repo
 ```bash
$ git clone git@github.com:cul-it/exhibits-library-cornell-edu.git
```

1. Install gems
 ```bash
$ cd <clone>
$ bundle install
```

1. Run database migrations
 ```bash
$ rake db:migrate
```

1. Copy example dotenv file
 ```bash
$ cp .env.example .env
```

1. Start Solr (via [solr_wrapper](https://github.com/cbeer/solr_wrapper))
 ```bash
$ bundle exec solr_wrapper
```
> Solr will be accessible at http://localhost:8983/solr
>
> solr_wrapper is configured to persist data between runs. Please refer to the [solr_wrapper documentation](https://github.com/cbeer/solr_wrapper#cleaning-your-repository-from-the-command-line) for details on purging persisted data.

1. Start Rails in new terminal session
 ```bash
$ rails s
```
> Visit the application at [http://localhost:3000](http://localhost:3000)
