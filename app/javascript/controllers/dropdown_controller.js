import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menu"]

    toggle(event) {
        event.stopPropagation()
        this.menuTarget.classList.toggle("show")

        // Add a click handler to the document to close the menu when clicking outside
        if (this.menuTarget.classList.contains("show")) {
            document.addEventListener("click", this.outsideClickHandler = this.close.bind(this))
        }
    }

    close() {
        this.menuTarget.classList.remove("show")
        document.removeEventListener("click", this.outsideClickHandler)
    }
}