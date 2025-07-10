class ChatRoomsController < ApplicationController
  def index
    @chat_rooms = ChatRoom.all
    @chat_room = ChatRoom.new
  end

  def show
    @chat_room = ChatRoom.find(params[:id])
    @messages = @chat_room.messages
  end

  def create
    @chat_room = ChatRoom.create(name: params[:chat_room][:name])
    redirect_to @chat_room
  end
end
