class AddChallengeIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :challenge_id, :integer, null: true
  end
end
