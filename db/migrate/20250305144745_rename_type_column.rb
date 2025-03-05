class RenameTypeColumn < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :type, :user_type
  end
end
