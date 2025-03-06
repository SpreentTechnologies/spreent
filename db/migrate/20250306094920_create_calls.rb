class CreateCalls < ActiveRecord::Migration[8.0]
  def change
    create_table :calls do |t|
      t.string :uuid
      t.string :status
      t.integer :caller_id
      t.integer :recipient_id

      t.timestamps
    end
    add_index :calls, :uuid, unique: true
  end
end
