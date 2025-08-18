# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Disable Rails logger to prevent huge log file & speed up inserts
Rails.logger = Logger.new(nil)
ActiveRecord::Base.logger = nil

puts "Cleaning up old data..."
Message.delete_all
Chat.delete_all
Application.delete_all

# Optional: Drop indexes before inserting massive data
ActiveRecord::Base.connection.execute("DROP INDEX IF EXISTS index_messages_on_chat_id;")
ActiveRecord::Base.connection.execute("DROP INDEX IF EXISTS index_chats_on_application_id;")

puts "Creating applications..."
applications = []
10.times do |i|
  applications << Application.create!(
    token: SecureRandom.hex(10),
    name: "Application #{i + 1}"
  )
end

puts "Creating chats..."
chats = []
applications.each do |app|
  100.times do |i|
    chats << Chat.create!(
      application: app,
      number: i + 1
    )
  end
end

puts "Creating messages..."
messages = []
chats.each do |chat|
  1_000.times do |i|
    messages << {
      chat_id: chat.id,
      number: i + 1,
      content: "Message #{i + 1} for chat #{chat.id}", # changed from body to content
      created_at: Time.now,
      updated_at: Time.now
    }
  end
end

# Bulk insert messages in one go (faster)
Message.insert_all(messages)

# Recreate indexes after bulk insert
puts "Recreating indexes..."
ActiveRecord::Base.connection.execute("CREATE INDEX index_messages_on_chat_id ON messages(chat_id);")
ActiveRecord::Base.connection.execute("CREATE INDEX index_chats_on_application_id ON chats(application_id);")

puts "Done! ✅"
