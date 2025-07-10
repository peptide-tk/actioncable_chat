class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    chat_room = ChatRoom.find(params[:chat_room_id])
    stream_from "chat_room_#{chat_room.id}"
    Rails.logger.info "User subscribed to chat room #{chat_room.id}"
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Chat room not found: #{params[:chat_room_id]}"
    reject
  end

  def unsubscribed
    Rails.logger.info "User unsubscribed from chat room"
  end
  
  def speak(data)
    chat_room = ChatRoom.find(params[:chat_room_id])
    message = chat_room.messages.create!(
      content: data['message'],
      username: data['username']
    )
    
    Rails.logger.info "Created message: #{message.inspect}"
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "Chat room not found: #{e.message}"
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create message: #{e.message}"
  rescue => e
    Rails.logger.error "Unexpected error in speak: #{e.message}"
  end
end
