class CreateChallengesTable < ActiveRecord::Migration[8.0]
  def change
    create_table :challenges do |t|
      t.string :title
      t.text :description

      t.references :community
      t.references :user

      t.timestamps
    end
  end
end
