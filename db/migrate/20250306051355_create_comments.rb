class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :post
      t.references :user
      t.string :content
      t.timestamps
    end
  end
end
