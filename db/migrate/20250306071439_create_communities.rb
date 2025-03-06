class CreateCommunities < ActiveRecord::Migration[8.0]
  def change
    create_table :communities do |t|
      t.string :name
      t.text :description
      t.references :sport, null: false, foreign_key: true

      t.timestamps
    end
  end
end
