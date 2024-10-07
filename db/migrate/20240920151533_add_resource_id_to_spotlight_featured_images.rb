class AddResourceIdToSpotlightFeaturedImages < ActiveRecord::Migration[7.0]
  def change
    add_reference :spotlight_featured_images, :spotlight_resource, foreign_key: true

    reversible do |direction|
      direction.up do    
        execute <<-SQL
          UPDATE spotlight_featured_images f, spotlight_resources r SET f.spotlight_resource_id = r.id WHERE r.upload_id = f.id;
        SQL
      end
      # Shouldn't really be running this in reverse, but just in case
      # This will set the upload_id to the first featured image id
      direction.down do
        execute <<-SQL
          UPDATE spotlight_resources r SET r.upload_id = (SELECT f.id FROM spotlight_featured_images f WHERE f.spotlight_resource_id = r.id LIMIT 1);
        SQL
      end
    end

    remove_index :spotlight_resources, :upload_id
    remove_column :spotlight_resources, :upload_id, :integer, after: :index_status
  end
end
