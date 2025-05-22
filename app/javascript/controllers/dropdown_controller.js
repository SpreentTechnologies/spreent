import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["menu"]

    connect() {
        console.log('Dropdown controller connected');
        console.log(this.menuTarget);
    }

    toggle(event) {
        event.stopPropagation()

        if (this.menuTarget.classList.contains("hidden")) {
            this.menuTarget.classList.remove('hidden');
        } else {
            this.menuTarget.classList.add('hidden');
        }
        

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