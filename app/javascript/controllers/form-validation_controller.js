import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
    static targets = ["input", "fileInput", "submitButton"]

    connect() {
        this.validateForm()
    }

    validateForm() {
        const hasText = this.inputTarget.value.trim().length > 0

        this.submitButtonTarget.disabled = !hasText;
    }
}