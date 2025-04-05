class AddCommunityIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :community_id, :integer, null: true
  end
end
