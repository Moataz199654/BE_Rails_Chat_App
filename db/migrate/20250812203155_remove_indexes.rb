class RemoveIndexes < ActiveRecord::Migration[8.0]
  def change
    remove_index :messages, :chat_id if index_exists?(:messages, :chat_id)
    remove_index :chats, :application_id if index_exists?(:chats, :application_id)
  end
end
