class AddResourceIdToSpotlightFeaturedImages < ActiveRecord::Migration[7.0]
  def change
    # This is a bit of a hack to get around the fact that PKs are still integers in int/stg/prod
    # https://culibrary.atlassian.net/browse/LP-1144
    id_data_type = Rails.env.test? || Rails.env.development? ? :bigint : :integer
    add_column :spotlight_featured_images, :spotlight_resource_id, id_data_type
    add_foreign_key :spotlight_featured_images, :spotlight_resources

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
