class AddUniqueIndexToChats < ActiveRecord::Migration[8.0]
  def change
    add_index :chats, [:application_id, :number] , unique: true
  end
end
