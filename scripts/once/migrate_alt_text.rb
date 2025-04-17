# One-time script to migrate the alt field in solr document page blocks to the new spotlight alt_text field
#     Note: This does NOT migrate captions to alt text for Uploaded Item Rows, as these are not 1:1 fields
# 
# To use: 
#    Open a rails console: RAILS_ENV=<RAILS_ENV> bundle exec rails c
#    Load the script: load 'scripts/once/migrate_alt_text.rb'
#    DRY RUN: Update 1 exhibit by exhibit id: AltTextMigrator.update_exhibit_pages(<exhibit_id>)
#      -> actually run: AltTextMigrator.update_exhibit_pages(<exhibit_id>, false)
#    DRY RUN: Update all exhibits by exhibit ids: AltTextMigrator.update_all_exhibits([<exhibit_id>, <exhibit_id>, ...])
#      -> actually run: AltTextMigrator.update_all_exhibits([<exhibit_id>, <exhibit_id>, ...], false)

class AltTextMigrator
  class << self
    def update_all_exhibits(exhibit_ids, dry_run=true)
      exhibit_ids.each do |id|
        begin
          update_exhibit_pages(id, dry_run)
        rescue StandardError => e
          puts "Error updating exhibit #{id}: #{e.message}"
          puts e.backtrace.join("\n")
          puts "Would you like to continue to the next exhibit? [y/n]"
          go_forth = gets.chomp == "y"
          if go_forth
            puts "Moving on to next exhibit..."
          else
            break
          end
        end
      end
    end

    def update_exhibit_pages(exhibit_id, dry_run=true)
      exhibit = Spotlight::Exhibit.find(exhibit_id)
      puts "Updating exhibit #{exhibit_id}..."
      puts "     Title: #{exhibit.title}"
      puts "     Page count: #{exhibit.pages.count}"

      exhibit.pages.each do |page|
        update_iiif_image_ids(page, dry_run)
      end
      puts "Finished updating exhibit #{exhibit_id}"
    end

    def update_iiif_image_ids(page, dry_run=true)
      puts "     Updating page #{page.id}: #{page.title}"
      page_with_solr_document_blocks_with_alt_text = false
      page.content.each do |block|
        if [SirTrevorRails::Blocks::SolrDocumentsBlock,
            SirTrevorRails::Blocks::SolrDocumentsFeaturesBlock,
            SirTrevorRails::Blocks::SolrDocumentsGridBlock,
            SirTrevorRails::Blocks::SolrDocumentsCarouselBlock].include?(block.class)
          block.item.each do |item_num, item_data|
            if item_num.include?('item_') && block.item[item_num]['alt'].present? && block.item[item_num]['alt_text'].blank? && block.item[item_num]['alt_text_backup'].blank?
              page_with_solr_document_blocks_with_alt_text = true
              if block.item[item_num]['decorative'] == 'on'
                block.item[item_num]['alt_text_backup'] = block.item[item_num]['alt']
              else
                block.item[item_num]['alt_text'] = block.item[item_num]['alt']
              end
            end
          end
        end
      end

      if page_with_solr_document_blocks_with_alt_text
        if dry_run
          puts "          DRY RUN"
        else
          # Update the model, not just the content object
          page.content = page.content
    
          # Save the page
          page.save!
          puts "          SUCCESS"
        end
      else
        puts "          SKIPPING: Page #{page.id} does not contain embedded exhibit items with old alt text to migrate"
      end
    end
  end
end
