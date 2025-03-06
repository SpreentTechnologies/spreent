// app/javascript/controllers/flash_controller.js (if using Stimulus)
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        this.showFlashMessages();
    }

    showFlashMessages() {
        const flashMessages = document.querySelectorAll('.flash-message');

        if (flashMessages.length === 0) return;

        // Add visible class with a slight delay between each
        flashMessages.forEach((message, index) => {
            setTimeout(() => {
                message.classList.add('visible');

                // Auto-hide after 5 seconds
                this.scheduleRemoval(message);

                // Set up click handler for close button
                const closeButton = message.querySelector('.close-alert');
                if (closeButton) {
                    closeButton.addEventListener('click', () => this.hideMessage(message));
                }
            }, index * 150); // Stagger the animations slightly
        });
    }

    scheduleRemoval(message) {
        setTimeout(() => {
            this.hideMessage(message);
        }, 5000);
    }

    hideMessage(message) {
        message.classList.add('hiding');
        message.classList.remove('visible');

        // Remove from DOM after animation completes
        setTimeout(() => {
            message.remove();
        }, 400); // Match the CSS transition duration
    }
}