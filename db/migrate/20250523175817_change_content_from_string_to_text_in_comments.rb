class ChangeContentFromStringToTextInComments < ActiveRecord::Migration[8.0]
  def up
    change_column :comments, :content, :text
  end

  def down
    change_column :comments, :content, :string
  end
end
