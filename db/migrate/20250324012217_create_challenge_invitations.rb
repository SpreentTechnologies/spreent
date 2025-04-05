class CreateChallengeInvitations < ActiveRecord::Migration[8.0]
  def change
    create_table :challenge_invitations do |t|
      t.references :challenge, null: false, foreign_key: true
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    # Add a unique index to prevent duplicate invitations
    add_index :challenge_invitations, [:challenge_id, :recipient_id], unique: true
  end
end