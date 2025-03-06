class AddLocationToCommunity < ActiveRecord::Migration[8.0]
  def change
    add_column :communities, :location, :string
  end
end
