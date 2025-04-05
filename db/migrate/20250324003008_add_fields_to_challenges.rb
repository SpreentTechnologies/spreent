class AddFieldsToChallenges < ActiveRecord::Migration[8.0]
  def change
    add_column :challenges, :rules, :text
    add_column :challenges, :start_date, :date, null: false
    add_column :challenges, :end_date, :date, null: true
    rename_column :challenges, :title, :name
  end
end
