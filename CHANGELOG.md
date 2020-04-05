### 2.0.2 (2020-04-05)

* spotlight version updated to v2.0.2
  * fixes an issue where you could browse though the Previous/Next record pagination from browse categories into negative numbers (or past the number of documents in the browse category)
  * change the field type of the the content column for Pages to increase the size from text to mediumtext
  * database migration for field type change for Pages  

### 2.0.1 (2020-04-05)

* spotlight version updated to v2.0.1
  * bug fixes only

### 2.0.0 (2020-04-03)

* spotlight version updated to v2.0.0
  * update spotlight to 2.0.0
  * migrations related to language support
  * update related dependencies
  * kept rails at 5.1.6, as an update to 5.2 requires too many other changes and is not required
* update customizations to be compatible with spotlight 2.0.0
* update dependencies and cleanup Gemfile

### 1.1.1 (2020-04-02)

* BUG FIX: give exhibit admin permission to upload a file as the masthead

### 1.1.0 (2020-03-30)

* spotlight version updated to v1.5.1
  * 5 database migrations
  * many dependency updates
* added spotlight version to footer
* refactors documentation to use Jekyll documentation theme

### 1.0.1 (2020-03-10)

* BUG FIX: patch s3 access to remove expiry token from attachment URLs

### 1.0.0 (2020-03-05)

First release on AWS

* add nginx configurations
* add maintenance mode
* setup sidekiq
* set logger logs' timezone to ET
* add scripts for data integrity investigation and repair
* BUG FIX: fixes error `has_many :through association 'Spotlight::Exhibit#owned_tags' which goes through 'Spotlight::Exhibit#owned_taggings’`
* remove library resources links from footer
* add processing for files on S3 via carrierwave_file_resolver
* prepare for deploy on AWS

See [commits in github](https://github.com/cul-it/exhibits-library-cornell-edu/commits/24129229e77a6cdf19426535e1a27008172bed3d) for work completed prior to Nov 2018.
