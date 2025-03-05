class ChangeUsersType < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :type, :string, default: 'user'
  end
end
