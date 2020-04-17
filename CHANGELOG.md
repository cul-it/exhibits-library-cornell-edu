### 2.5.0 (2020-04-17)

* spotlight version updated to v2.5.1
  * updates riiif to 2.0
  * updates i18n to 1.8.2
  * sets up anonymizeIP configuration for Google Analytics
  * fixes a bug where urls in some feature page widgets that had underscores would be converted to italics

### 2.4.2 (2020-04-16)

* put pin of autoprefixer-rails back in place
* put pin of sprockets back in place

### 2.4.1 (2020-04-16)

* spotlight version updated to v2.4.1
  * validate the FeaturedImage object if provided
  * avoid using javascript keywords as variable names

### 2.4.0 (2020-04-16)

* spotlight version updated to v2.4.0
  * allow dots to appear in the identifier
  * require update to blacklight v6.20
* update to blacklight v6.20
  * add custom routing constraints by setting
* update to blacklight v6.19
  * fixes an issue where citations are rendering in un-styled modals
  * move asset generating to the assets generator
  * use solr_wrapper config file for collection configuration
* update to blacklight v6.17
  * adds support to configure an error callback for selections
* update to blacklight v6.16
  * avoids unnecessary field lookup for configs that are present for a specific type. Adds deprecation warnings going forward.
  * improves accessibility of per page, fact toggle, and sort buttons
  * adds deprecation warnings for discard_flash_if_xhr
  * fixes an issue where the searchbox in Safari is broken
  * fixes an issue where Bookmark checkboxes would update, even though the request failed

### 2.3.3 (2020-04-16)

* spotlight version updated to v2.3.2
  * use the same logic as the rest of the app for determining whether to render the search bar or not
  * fixed typo in method name for CarrierwaveFileResolver
  * includes flash when redirecting from exhibits home page
  
### 2.3.2 (2020-04-16)

* spotlight version updated to v2.3.2
  * fixes a bug that prevents changes on page edit forms from persisting (see sul-dlss/exhibits#1326 for more info)

### 2.3.1 (2020-04-16)

* spotlight version updated to v2.3.1
  * enable facets in newly generated applications
  * increase the maximum number of feature pages
  * fix the caption fallback for the slideshow feature block

### 2.3.0 (2020-04-15)

* spotlight version updated to v2.3.0
  * added the ability to explicitly configure which Solr fields an upload field belongs to
  * changed Taggable id type and fixed an Exhibit tags bug
  * requires database migration for change of taggable_id to integer type

### 2.2.1 (2020-04-05)

* spotlight version updated to v2.2.1
  * fixes an issue where show fields were not showing up as sorted in the metadata administrator panel.
    
### 2.2.0 (2020-04-05)

* spotlight version updated to v2.2.0
  * make several changes to fix the build, including updating our Rubocop todo, and requiring i18n < 1.1 as i18n introduced a backwards incompatible change with Rails (rails/rails#33574)
  * Updates our CI to build with Rails 5.2.1
  * adds new locale files for Chinese and Italian languages
  * Update the PaperTrails versions table to be larger to accommodate large Spotlight::Page
  * Uses textarea for free form text input

### 2.1.0 (2020-04-05)

* spotlight version updated to v2.1.0
  * allows the application catalog config to provide values for custom fields
  * enables a Spotlight application to add custom attributes to be shown on a SirTrevor Widget edit form  

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
