class AddLevelToCommunities < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :level, :integer
  end
end
