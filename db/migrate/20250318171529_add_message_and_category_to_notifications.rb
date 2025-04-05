class AddMessageAndCategoryToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_column :notifications, :message, :string
    add_column :notifications, :category, :integer
  end
end
