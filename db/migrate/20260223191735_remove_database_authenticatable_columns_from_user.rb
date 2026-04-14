class RemoveDatabaseAuthenticatableColumnsFromUser < ActiveRecord::Migration[8.1]
  def change
    ## Recoverable
    remove_index :users, :reset_password_token, unique: true
    remove_column :users, :reset_password_token, :string
    remove_column :users, :reset_password_sent_at, :datetime, precision: nil

    ## Rememberable
    remove_column :users, :remember_created_at, :datetime, precision: nil
  end
end
