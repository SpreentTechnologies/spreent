import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["fileInput", "fileList"]

    connect() {
        this.fileUploading = false
        this.uploadComplete = false
    }

    triggerFileInput(event) {
        this.fileInputTarget.click()
    }

    // Use a Stimulus action to handle the change event
    // Add data-action="change->file-upload#updateFileList" to your file input element
    updateFileList() {
        // Check if already uploading or completed
        if (this.fileUploading || this.uploadComplete) {
            return
        }

        this.fileUploading = true
        const files = this.fileInputTarget.files
        this.fileListTarget.innerHTML = ''
        const uploadPreview = document.getElementById('upload-preview')

        // Clear previous previews to prevent duplicates
        if (uploadPreview) {
            uploadPreview.innerHTML = ''
        }

        if (files.length) {
            const list = document.createElement('ul')
            list.className = 'file-list'

            let filesProcessed = 0

            Array.from(files).forEach(file => {
                const reader = new FileReader()

                reader.onload = (event) => {
                    const img = document.createElement('img')
                    img.src = event.target.result
                    img.style.width = '100%'
                    img.style.height = '100%'

                    if (uploadPreview) {
                        uploadPreview.appendChild(img)
                    }

                    filesProcessed++

                    // Mark as complete when all files are processed
                    if (filesProcessed === files.length) {
                        this.fileUploading = false
                        this.uploadComplete = true
                    }
                }

                reader.readAsDataURL(file)
            })

            this.fileListTarget.appendChild(list)
        } else {
            this.fileUploading = false
        }
    }

    // Add this method to reset state when starting a new upload
    reset() {
        this.fileUploading = false
        this.uploadComplete = false
        this.fileInputTarget.value = '' // Clear the file input
        this.fileListTarget.innerHTML = ''
        const uploadPreview = document.getElementById('upload-preview')
        if (uploadPreview) {
            uploadPreview.innerHTML = ''
        }
    }
}
