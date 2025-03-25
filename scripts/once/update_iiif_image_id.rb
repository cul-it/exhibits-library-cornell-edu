# One-time script to set iiif_image_id for all pages potentially containing items with multiple images
# 
# To use: 
#    Open a rails console: RAILS_ENV=<RAILS_ENV> bundle exec rails c
#    Load the script: load 'scripts/once/update_iiif_image_id.rb'
#    List exhibits with items containing multiple images: PageBlockUpdater.exhibits_with_multi_image_items
#    DRY RUN: Update 1 exhibit by exhibit id: PageBlockUpdater.update_exhibit_pages(<exhibit_id>)
#      -> actually run: PageBlockUpdater.update_exhibit_pages(<exhibit_id>, false)
#    DRY RUN: Update all exhibits by exhibit ids: PageBlockUpdater.update_all_exhibits([<exhibit_id>, <exhibit_id>, ...])
#      -> actually run: PageBlockUpdater.update_all_exhibits([<exhibit_id>, <exhibit_id>, ...], false)

class PageBlockUpdater
  class << self
    # Exhibits with at least 1 item that has multiple images
    def exhibits_with_multi_image_items
      exhibit_ids = Spotlight::Resources::Upload.joins(:uploads).group('spotlight_resources.id').having('COUNT(spotlight_featured_images.id) > 1').pluck(:exhibit_id).uniq
      puts "Exhibits containing items with multiple images: #{exhibit_ids}"
      exhibit_ids
    end

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
      page_with_solr_document_blocks = false
      page.content.each do |block|
        if [SirTrevorRails::Blocks::SolrDocumentsBlock,
            SirTrevorRails::Blocks::SolrDocumentsEmbedBlock,
            SirTrevorRails::Blocks::SolrDocumentsFeaturesBlock,
            SirTrevorRails::Blocks::SolrDocumentsGridBlock,
            SirTrevorRails::Blocks::SolrDocumentsCarouselBlock].include?(block.class)
          page_with_solr_document_blocks = true
          block.item.each do |item_num, item_data|
            if item_num.include?('item_') && block.item[item_num]['iiif_canvas_id'].present?
              block.item[item_num]['iiif_image_id'] = block.item[item_num]['iiif_canvas_id'].gsub('/canvas/', '/annotation/')
            end
          end
        end
      end

      if page_with_solr_document_blocks
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
        puts "          SKIPPING: Page #{page.id} does not contain embedded exhibit items"
      end
    end
  end
end
