class AddSenderRecipientToConversations < ActiveRecord::Migration[8.0]
  def change
    add_column :conversations, :sender_id, :bigint, null: false
    add_column :conversations, :recipient_id, :bigint, null: false
  end
end
