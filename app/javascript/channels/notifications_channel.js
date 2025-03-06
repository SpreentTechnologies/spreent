import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log('Connected to NotificationsChannel');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    const notificationCount = document.querySelector('#notification-count');
    const count = parseInt(notificationCount.textContent);
    notificationCount.textContent = count + 1
  }
});
