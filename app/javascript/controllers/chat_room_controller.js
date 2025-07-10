import { Controller } from "@hotwired/stimulus";
import {
  subscribeToChatRoom,
  unsubscribeFromChatRoom,
} from "channels/chat_room_channel";

export default class extends Controller {
  static targets = ["messages", "message", "username"];
  static values = { roomId: Number };

  connect() {
    this.subscription = subscribeToChatRoom(this.roomIdValue, {
      received: (data) => {
        this.addMessage(data);
      },
    });

    this.usernameTarget.value = localStorage.getItem("username") || "";
    this.messageTarget.addEventListener("keypress", (e) => {
      if (e.key === "Enter") this.send();
    });
    this.scrollToBottom();
  }

  disconnect() {
    unsubscribeFromChatRoom(this.roomIdValue);
  }

  send() {
    const message = this.messageTarget.value.trim();
    const username = this.usernameTarget.value.trim();

    if (message && username) {
      this.subscription.speak(message, username);
      this.messageTarget.value = "";
      localStorage.setItem("username", username);
    }
  }

  addMessage(data) {
    const div = document.createElement("div");
    div.className = "message";
    div.innerHTML = `
      <div class="message-header">
        ${data.username}
        
        <span class="message-time">${data.created_at}</span>
      </div>
      <div>${data.content}</div>
    `;
    this.messagesTarget.appendChild(div);
    this.scrollToBottom();
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;
  }
}
