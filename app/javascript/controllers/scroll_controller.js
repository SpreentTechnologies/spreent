import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
    static targets = ["container"]

    connect() {
        this.scrollToBottom()
    }

    scrollToBottom() {
        const container = this.containerTarget

        container.scrollTop = container.scrollHeight
    }

    // Call this method whenever new content is added
    scrollAfterNewContent() {
        // You can add a small delay if needed for DOM updates
        setTimeout(() => {
            this.scrollToBottom()
        }, 50);
    }

    smoothScrollToBottom() {
        const container = this.containerTarget

        container.scroll({
            top: container.scrollHeight,
            behavior: 'smooth'
        })
    }
}