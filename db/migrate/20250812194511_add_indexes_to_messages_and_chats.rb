class AddIndexesToMessagesAndChats < ActiveRecord::Migration[8.0]
  def change
    add_index :messages , :chat_id
    add_index :chats , :number
  end
end
