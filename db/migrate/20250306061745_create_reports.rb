class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :post, null: false, foreign_key: true
      t.string :reason, null: false
      t.string :status, default: "pending"
      t.text :details
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
