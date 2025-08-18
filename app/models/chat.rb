class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages

  validates :number, uniqueness: { scope: :application_id }
end
