class AddUniqueIndexToMessages < ActiveRecord::Migration[8.0]
  def change
    add_index :messages, [:chat_id, :number], unique: true
  end
end
