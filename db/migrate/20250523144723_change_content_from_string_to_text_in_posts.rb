class ChangeContentFromStringToTextInPosts < ActiveRecord::Migration[8.0]
  def up
    change_column :posts, :content, :text
  end

  def down
    change_column :posts, :content, :string
  end
end
