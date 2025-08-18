class Message < ApplicationRecord
  belongs_to :chat,  counter_cache: true

  validates :number, uniqueness: { scope: :chat_id }
end
