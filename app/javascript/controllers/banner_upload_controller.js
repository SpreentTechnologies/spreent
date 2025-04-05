import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["fileInput"]

    triggerFileInput() {
        this.fileInputTarget.click()
    }

    uploadFile() {
        // Show loading indicator if desired
        this.element.classList.add("uploading")

        // Submit the form automatically when file is selected
        const form = document.getElementById("banner-form")
        form.requestSubmit()
    }
}