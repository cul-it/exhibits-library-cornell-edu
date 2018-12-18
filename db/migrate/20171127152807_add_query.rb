class AddQuery < ActiveRecord::Migration[4.2]
  def up
   add_column :spotlight_resources, :query, :text
   add_column :spotlight_resources, :rows, :integer
 end

 def down
   remove_column :spotlight_resources, :query, :text
   remove_column :spotlight_resources, :rows, :integer
 end
end
