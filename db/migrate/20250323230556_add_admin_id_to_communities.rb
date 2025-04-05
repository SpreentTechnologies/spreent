class AddAdminIdToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :admin_id, :integer
  end
end
