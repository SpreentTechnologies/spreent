class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :bio, :text
    add_column :users, :public_email, :boolean, default: false
    add_column :users, :theme_preference, :string, default: 'system'
    add_column :users, :notification_preferences, :string, default: ''
  end
end
