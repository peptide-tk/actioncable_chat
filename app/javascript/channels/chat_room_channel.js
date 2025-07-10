import consumer from "channels/consumer";

const chatRoomChannels = {};

export function subscribeToChatRoom(chatRoomId, callbacks) {
  if (chatRoomChannels[chatRoomId]) {
    chatRoomChannels[chatRoomId].unsubscribe();
  }

  chatRoomChannels[chatRoomId] = consumer.subscriptions.create(
    { channel: "ChatRoomChannel", chat_room_id: chatRoomId },
    {
      received(data) {
        if (callbacks.received) callbacks.received(data);
      },

      speak(message, username) {
        this.perform("speak", { message, username });
      },
    }
  );

  return chatRoomChannels[chatRoomId];
}

export function unsubscribeFromChatRoom(chatRoomId) {
  if (chatRoomChannels[chatRoomId]) {
    chatRoomChannels[chatRoomId].unsubscribe();
    delete chatRoomChannels[chatRoomId];
  }
}
