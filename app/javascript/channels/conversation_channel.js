import consumer from "./consumer"

document.addEventListener('turbo:load', () => {
    const messagesContainer = document.getElementById('messages')

    if (messagesContainer) {
        const conversationId = messagesContainer.dataset.conversationId

        consumer.subscriptions.create({ channel: "ConversationChannel", conversation_id: conversationId }, {
            connected() {
                // Called when the subscription is ready for use on the server
                console.log("Connected to conversation channel")
            },

            disconnected() {
                // Called when the subscription has been terminated by the server
            },

            received(data) {
                // Called when there's incoming data on the websocket for this channel
                if (data.conversation_id === parseInt(conversationId)) {
                    const messageElement = document.createElement('div')
                    messageElement.innerHTML = data.message
                    messagesContainer.appendChild(messageElement.firstChild)
                    messagesContainer.scrollTop = messagesContainer.scrollHeight
                }
            }
        })

        messagesContainer.scrollTop = messagesContainer.scrollHeight
    }
})