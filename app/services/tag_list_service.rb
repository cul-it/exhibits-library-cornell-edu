# frozen_string_literal: true
### CUSTOMIZATION (elr) - new service class that lists our supported exhibit level tags (controls filter links at top of home page)

class TagListService
  def self.tag_list
    ["Arts and Design",
     "Food and Agriculture",
     "Gender and Sexuality",
     "Humanities and Social Science",
     "Industry and Labor",
     "Science and Technology",
     "Cornelliana"]
  end
end
