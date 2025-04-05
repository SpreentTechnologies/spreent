import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form", "input", "results"]
    static values = {
        cursorPosition: Number
    }

    connect() {
        console.log("Live search controller connected")
    }

    search() {
        // Save cursor position
        this.cursorPositionValue = this.inputTarget.selectionStart

        // Debounce the search
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            // Only trigger search if input has at least 1 character or is empty
            if (this.inputTarget.value.length >= 0) {
                // Store the current input value before submission
                this.currentValue = this.inputTarget.value

                // Submit the form
                this.formTarget.requestSubmit()
            }
        }, 300) // Debounce for 300ms
    }

    // After the Turbo Stream request completes
    afterUpdate(event) {
        // Refocus the input field
        this.inputTarget.focus()

        // Restore input value in case it was reset
        if (this.currentValue) {
            this.inputTarget.value = this.currentValue
        }

        // Restore cursor position
        if (this.cursorPositionValue) {
            this.inputTarget.setSelectionRange(this.cursorPositionValue, this.cursorPositionValue)
        }
    }

    clear() {
        this.inputTarget.value = ""
        this.formTarget.requestSubmit()

        // Focus the input after clearing
        setTimeout(() => {
            this.inputTarget.focus()
        }, 10)
    }
}