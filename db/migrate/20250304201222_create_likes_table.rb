class CreateLikesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :likes do |t|
      t.references :user, index: true
      t.references :likeable, polymorphic: true, null: false

      t.timestamps
    end

    add_index :likes, [:likeable_id, :likeable_type], unique: true
  end
end
