class Message < ApplicationRecord
  belongs_to :chat_room
  
  after_create_commit :broadcast_message
  
  private
  
  def broadcast_message
    ActionCable.server.broadcast(
      "chat_room_#{chat_room.id}",
      {
        id: id,
        content: content,
        username: username,
        created_at: created_at.strftime("%H:%M")
      }
    )
  end
end
