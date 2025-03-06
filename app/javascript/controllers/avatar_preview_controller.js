import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["preview"]

    showPreview(event) {
        const input = event.target
        const preview = this.previewTarget

        // Clear previous preview
        preview.innerHTML = ""

        if (input.files && input.files[0]) {
            const reader = new FileReader()

            reader.onload = (e) => {
                const img = document.createElement("img")
                img.src = e.target.result
                img.classList.add("preview-img")
                preview.appendChild(img)
            }

            reader.readAsDataURL(input.files[0])
        }
    }
}