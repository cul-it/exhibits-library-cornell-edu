# List all database entries related to an exhibit:

# To use:
#   Run rails console: bundle exec rails c <RAILS_ENV>
#   Load the script: load 'scripts/data_studio.rb'
#   Get code to use in Google Data Studio:
#     DataStudio.exhibits_field
#     DataStudio.include_published_exhibits_filter
#     DataStudio.admin_pages_field
#     DataStudio.exclude_admin_pages_filter

class DataStudio
  # To setup the Published Exhibits field in Data Studio:
  #   * click any widget that uses data
  #   * select DATA tab on right
  #   * click ADD A FIELD
  #   * set Field Name to Exhibits
  #   * set Formula to the results of this method
  def self.exhibits_field
    instructions = <<-INSTRUCTIONS
# To setup the Exhibits field in Data Studio:
#   * click any widget that uses data
#   * select DATA tab on right
#   * click ADD A FIELD
#   * set Field Name to Exhibits
#   * set Formula to the results of this method
# DO NOT INCLUDE THESE INSTRUCTIONS IN THE FORMULA

    INSTRUCTIONS

    exhibits = Spotlight::Exhibit.where(published: true)

    field = "CASE\n"
    exhibits.each do |ex|
      field += "WHEN (REGEXP_MATCH(Page, \".*#{ex.slug}.*\")) THEN \"#{ex.title}\"\n"
    end
    field += "ELSE 'Unpublished'\nEND"

    puts instructions
    puts ' '
    puts field
    puts ' '
    field
  end

  def self.include_published_exhibits_filter
    instructions = <<-INSTRUCTIONS
# To setup the filter in Data Studio:
#   * select menu Resource -> Manage filters
#   * click + ADD A FILTER
#   * set Filter Name to Published Exhibits filter
#   * set Filter to...
#       Exclude   Exhibits    In    Unpublished
#     where Exhibits is the field setup by method .exhibits_field
#     where Unpublished is the results of this method
# DO NOT INCLUDE THESE INSTRUCTIONS IN THE FORMULA
    INSTRUCTIONS

    filter = "Unpublished"

    puts instructions
    puts ' '
    puts filter
    puts ' '
    filter
  end

  def self.admin_pages_field
    instructions = <<-INSTRUCTIONS
# To setup the field in Data Studio:
#   * click any widget that uses data
#   * select DATA tab on right
#   * click ADD A FIELD
#   * set Field Name to Admin Pages
#   * set Formula to the results of this method
# DO NOT INCLUDE THESE INSTRUCTIONS IN THE FORMULA
    INSTRUCTIONS

    field = <<-FIELD
CASE
WHEN (REGEXP_MATCH(Page, '.*dashboard.*')) THEN "Dashboard"
WHEN (REGEXP_MATCH(Page, '.*/edit')) THEN "Edit"
WHEN (REGEXP_MATCH(Page, '.*/edit#.*')) THEN "Edit Tabs"
WHEN (REGEXP_MATCH(Page, '.*/edit/.*')) THEN "Edit Item"
WHEN (REGEXP_MATCH(Page, '.*/users')) THEN "Users"
WHEN (REGEXP_MATCH(Page, '.*/admin_users')) THEN "Admin Users"
WHEN (REGEXP_MATCH(Page, '.*custom_fields.*')) THEN "Custom Fields"
WHEN (REGEXP_MATCH(Page, '.*custom_search_fields.*')) THEN "Custom Search Fields"
WHEN (REGEXP_MATCH(Page, '.*catalog/admin.*')) THEN "Item Curation"
WHEN (REGEXP_MATCH(Page, '.*resources/new.*')) THEN "New Item Curation"
WHEN (REGEXP_MATCH(Page, '.*/new')) THEN "New Exhibit Curation"
WHEN (REGEXP_MATCH(Page, '.*tags')) THEN "Tag Curation"
WHEN (REGEXP_MATCH(Page, '.*searches')) THEN "Browse Curation"
WHEN (REGEXP_MATCH(Page, '.*feature')) THEN "Feature Curation"
WHEN (REGEXP_MATCH(Page, '.*feature#add-new')) THEN "Feature Curation (new)"
WHEN (REGEXP_MATCH(Page, '.*about')) THEN "About Curation"
WHEN (REGEXP_MATCH(Page, '.*about#add-new')) THEN "About Curation (new)"
ELSE "Public Pages"
END
    FIELD

    puts instructions
    puts ' '
    puts field
    puts ' '
    field
  end

  def self.exclude_admin_pages_filter
    instructions = <<-INSTRUCTIONS
# To setup the filter in Data Studio:
#   * select menu Resource -> Manage filters
#   * click + ADD A FILTER
#   * set Filter Name to Exclude Admin Pages filter
#   * set Filter to...
#       Exclude   Admin Pages    In    Dashboard,Edit,Edit Tab,...
#     where Admin Pages is the field setup by method .admin_pages_field
#     where Dashboard,Edit,Edit Tab,... is the results of this method
# DO NOT INCLUDE THESE INSTRUCTIONS IN THE FORMULA
    INSTRUCTIONS

    filter = "Dashboard,Edit,Edit Tabs,Edit Item," \
             "Users,Admin Users,Custom Fields,Custom Search Fields," \
             "Item Curation,New Item Curation,New Exhibit Curation," \
             "Tag Curation,Browse Curation," \
             "Feature Curation,Feature Curation (new)," \
             "About Curation,About Curation (new)"

    puts instructions
    puts ' '
    puts filter
    puts ' '
    filter
  end
end
