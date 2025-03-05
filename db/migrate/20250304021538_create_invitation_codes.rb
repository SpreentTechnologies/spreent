class CreateInvitationCodes < ActiveRecord::Migration[8.0]
  def change
    create_table :invitation_codes do |t|
      t.string :code
      t.datetime :expires_at
      t.integer :max_uses
      t.integer :used_count

      t.timestamps
    end
  end
end
