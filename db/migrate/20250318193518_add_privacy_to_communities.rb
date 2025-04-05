class AddPrivacyToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :privacy, :integer
  end
end
