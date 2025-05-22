import consumer from "channels/consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    console.log('Connected to NotificationsChannel');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const notificationsCount = document.getElementById('notifications_count');

    if (notificationsCount) {
      notificationsCount.classList.remove('hidden');
      const count = parseInt(notificationsCount.textContent);
      notificationsCount.textContent = count + 1;
    }
  }
});
