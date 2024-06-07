import consumer from "./consumer"

consumer.subscriptions.create("ChatChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the chat channel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const messages = document.getElementById('messages');
    messages.innerHTML += data.message;
  },

  send_message(message, user_id) {
    this.perform('send_message', { message: message, user_id: user_id });
  }
});

// Handling the message form submission
document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('message_content');
  const button = document.querySelector('input[type="submit"]');
  const userId = document.getElementById('message_user_id').value;

  button.addEventListener('click', (e) => {
    e.preventDefault();
    const message = input.value;
    consumer.subscriptions.subscriptions[0].send_message(message, userId);
    input.value = '';
  });
});
