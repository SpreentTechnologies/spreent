import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static values = {
        debounceTime: { type: Number, default: 300 }
    }

    connect() {
        this.timeout = null
    }

    debounce(event) {
        clearTimeout(this.timeout)

        this.timeout = setTimeout(() => {
            this.element.form.requestSubmit()
        }, this.debounceTimeValue)
    }
}