import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        // Add keyboard event listener for ESC key
        this.escapeHandler = this.handleEscKey.bind(this)
        document.addEventListener("keydown", this.escapeHandler)
    }

    disconnect() {
        // Clean up event listener
        document.removeEventListener("keydown", this.escapeHandler)
    }

    open() {
        this.element.classList.add("open")
        document.body.classList.add("modal-open")
    }

    close() {
        this.element.classList.remove("open")
        document.body.classList.remove("modal-open")

        // Clear the Turbo Frame content after closing
        setTimeout(() => {
            const frame = document.getElementById("modal_frame")
            if (frame) frame.innerHTML = ""
        }, 300) // Delay to allow transition to complete
    }

    handleEscKey(event) {
        if (event.key === "Escape") {
            this.close()
        }
    }
}