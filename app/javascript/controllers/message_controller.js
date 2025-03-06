import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "form"]

    connect() {
        this.scrollToBottom()
        this.setupFormReset()
    }

    scrollToBottom() {
        const container = this.containerTarget
        container.scrollTop = container.scrollHeight
    }

    setupFormReset() {
        this.formTarget.addEventListener('turbo:submit-end', () => {
            this.formTarget.reset()
            this.scrollToBottom()
        })
    }
}