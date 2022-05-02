### 3.0.0 (2022-05-TBD)

* update to Spotlight 3.1.0
  * remove stale customizations
  * remove Portal code due to conflicts 
* update to Blacklight 7.19.0
* update to Bootstrap 4.6.0
* update to Ruby 2.7.3
* update to Bixby 3.0.2 (for Rubocop)
* update to AWS Linux 2
  * update ebextensions
  * update Puma to 5.3.2
* update to current library branding specs
* improve accessibility

### 2.21.0 (2021-04-13)

* update rails to 5.2.5 to fix mimemagic gem yank
* add documentation for the pages widget

### 2.20.0 (2021-02-11)

* update production database tables to use utf8 allowing for internationalization

### 2.19.1 (2021-02-08)

* fix fails to skip reindex error due to misspelling of exhibit_or_resources variable

### 2.19.0 (2021-02-01)

* revert removal of video widget - caused problems with previously uploaded videos

### 2.18.0 (2021-01-28)

* remove support for video widget
* add documentation for heading, text, list, quote, and hr widgets
* update dependencies
* add CircleCI as continuous integration testing in GitHub
* add Docker configs for local and CCI testing (experimental for use in browser)
* add first test to simply test that users can login
* limit tag to curated set on New Exhibit form
* use exhibit creator language instead of administrator

### 2.17.12 (2020-11-20)

* show at least documentation links in sidebar for all logged in users

### 2.17.11 (2020-11-20)

* add analytics dashboard

### 2.17.10 (2020-11-05)

* CloudFront requires more testing -- removed
* remove override of featured_pages_block - problem fixed in spotlight

### 2.17.9 (2020-09-18)

* setup CloudFront pre-loading of assets

### 2.17.8 (2020-09-18)

* add ebextension file for awslogs in CloudWatch
* update to rails 5.2.4.4

### 2.17.7 (2020-08-10)

* add google analytics

### 2.17.6 (2020-08-10)

* restrict exhibit tags to controlled list

### 2.17.5 (2020-08-10)

* FIX: move nav-btn css definition
* FIX: flow one card at a time to next row when reducing width

### 2.17.4 (2020-08-06)

* move login to footer
* remove extra links from header for public users
* set the color for create exhibit button to make it easier to see

### 2.17.3 (2020-08-06)

* limit privileges of administrators to creating exhibits
* grant full privileges to site admins

### 2.17.2 (2020-08-06)

* display 4 exhibits per row when no sidebar
* in right side menu, do not show users actions they cannot perform

### 2.17.1 (2020-08-06)

* cleanup comments for v2.17 - no code changes

### 2.17.0 (2020-08-05)

* add okcomputer health check for solr, database, cache, app, sidekiq
* get versions for spotlight and app from code instead of hardcoding
* rubocop repairs

### 2.16.0 (2020-08-04)

* update to ruby 2.5.8 and rails 5.2.4

### 2.15.0 (2020-06-16)

* update dependencies to address security vulnerabilities - kaminari, websockets-extensions
* set up environment variables for configuring action mailer in stg and prod environments

### 2.14.1 (2020-05-21)

* add examples directory holding example csv for multi-item upload
* only show tabs for Add Item that are valid choices in our system

### 2.14.0 (2020-05-21)

* use letter opener gem for testing email notifications in dev environment
* prevent add from CSV job from running again when email notification fails
* minor adjustment to reset password notification to add source as CUL-Online Exhibits
* adjust permissions for debug logger to allow writing
* clean up environment variables and add examples

### 2.13.4 (2020-05-20)
   
* override entire ReindexJob instead of prepend
* make sidekiq logger statements write to production log
* skip exceptions in perform_before block as well as perform method
  
### 2.13.3 (2020-05-20)
   
* skip exceptions when reindexing exhibits and log info about the failing resource 
  
### 2.13.2 (2020-05-05)
   
* make update_bundler ebextension script configurable with environment variables
  
### 2.13.1 (2020-05-05)
   
* update ruby for update_bundler ebextension script to 2.5.8
  
### 2.13.0 (2020-04-30)
   
* spotlight version updated to v2.13.0
  * Add Spotlight::ValidityChecker for checking if a job (e.g. indexing) still needs to be run to avoid doing duplicate work
  
### 2.12.1 (2020-04-30)
   
* spotlight version updated to v2.12.1
  * requires migration to add a unique constraints to solr document sidecars
     
### 2.12.0 (2020-04-30)

* spotlight version updated to v2.12.0
  * fixes bug where uploaded images are no longer able to be viewed in a IIIF viewer
  * HTML lang attribute should now reflect the current i18n locale

### 2.11.0 (2020-04-30)

* spotlight version updated to v2.11.0
  * add UI controls for making a user a site administrator
  * fix a regression in generating IIIF manifests for sites served over https
    
### 2.10.1 (2020-04-30)

* migrate table for custom search fields (required for spotlight v2.10.0)

### 2.10.0 (2020-04-30)

* spotlight version updated to v2.10.0
  * allow importing IIIF manifests with multilingual metadata
  * allow curators to specify exhibit-specific configuration for search fields
  * add some configuration to allow uploaded field mappings to provide processing directives
  * allow applications to use an external (non-riiif) IIIF server for image derivative requests

### 2.9.0 (2020-04-30)

* spotlight version updated to v2.9.0
  * fix a bug with paginating through search results embedded on a feature page
  * fix a bug rendering the edit form for a feature page that tries to display a deleted page

### 2.8.1 (2020-04-30)

* display the header with a different background color for each Rails env

### 2.8.0 (2020-04-30)

* add web accessibility assistance link in footer
* spotlight version updated to v2.8.0
  * requires db migration
  * add-and-continue stays on the same tab when adding items
  * bulk add forwards to exhibit page after adding items
  * allow items to be added without an image
  * allow custom field types to be configured as facetable
  * add support for multi-valued custom fields

### 2.7.0 (2020-04-17)

* spotlight version updated to v2.7.2
  * use paginated facets for exhibit tags

### 2.6.0 (2020-04-17)

* spotlight version updated to v2.6.1.1
  * add help block text for image upload areas

### 2.5.1 (2020-04-17)

* spotlight v2.5 required initializer config change for riiif

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
