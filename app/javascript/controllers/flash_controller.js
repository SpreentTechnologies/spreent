import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["message"]

    connect() {
        // Auto-dismiss flash message after 5 seconds
        setTimeout(() => {
            this.dismiss()
        }, 5000)
    }

    dismiss() {
        this.element.classList.add("flash-dismissing")

        // Remove element after animation completes
        this.element.addEventListener("animationend", () => {
            this.element.remove()
        }, { once: true })
    }
}