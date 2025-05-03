import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["fileInput", "preview", "progress"]
    static values = {
        url: String,
        param: String,
        maxSize: Number,
        acceptedTypes: Array,
        maxFiles: { type: Number, default: 10 }
    };

    connect() {
        this.files = []
        this.reset()
    }

    triggerFileInput(event) {
        this.fileInputTarget.click()
    }

    fileSelected(event) {
        const newFiles = this.fileInputTarget.files

        if (newFiles && newFiles.length) {
            this.addFiles(newFiles)
            this.fileInputTarget.value = ""
        }
    }

    addFiles(newFiles) {
        if (this.files.length + newFiles.length > this.maxFilesValue) {
            alert(`You can only upload a maximum of ${this.maxFilesValue} files`);
            return
        }

        // Convert FileList to Array and filter valid files
        const validFiles = Array.from(newFiles).filter(file => this.validateFile(file))

        // Add valid files to our collection
        this.files = [...this.files, ...validFiles]

        // Update the preview for all files
        this.updatePreviews()
    }

    validateFile(file) {
        // Check file type if specified
        if (this.hasAcceptedTypesValue) {
            if (!this.acceptedTypesValue.some(type => file.type.includes(type))) {
                alert(`File type ${file.type} is not supported. Accepted types: ${this.acceptedTypesValue.join(', ')}`)
                return false
            }
        }

        // Check file size if specified
        if (this.hasMaxSizeValue) {
            const maxBytes = this.maxSizeValue * 1024 * 1024
            if (file.size > maxBytes) {
                alert(`File ${file.name} exceeds maximum allowed size of ${this.maxSizeValue}MB`)
                return false
            }
        }

        return true
    }

    // Helper to format file size
    formatFileSize(bytes) {
        if (bytes < 1024) return bytes + ' bytes'
        else if (bytes < 1048576) return (bytes / 1024).toFixed(1) + ' KB'
        else return (bytes / 1048576).toFixed(1) + ' MB'
    }

    updatePreviews() {
        if (!this.hasPreviewTarget) return

        this.previewTarget.innerHTML = "";

        if (this.files.length === 0) {
            this.previewTarget.classList.add('hidden')
        }
        this.previewTarget.classList.remove("hidden")

        this.files.forEach((file, index) => {
            const previewItem = document.createElement("div")
            previewItem.classList.add("preview-item")

            // Add preview content based on file type
            if (file.type.includes("image/")) {
                const img = document.createElement("img")
                img.classList.add("w-[150px]")

                const reader = new FileReader()
                reader.onload = (e) => {
                    img.src = e.target.result
                }
                reader.readAsDataURL(file)

                previewItem.appendChild(img)
            } else {
                const icon = document.createElement("div")
                icon.classList.add("file-icon")
                // Set icon based on file type
                icon.innerHTML = this.getFileIcon(file.type)
                previewItem.appendChild(icon)
            }

            // Add remove button
            const removeBtn = document.createElement("button")
            removeBtn.classList.add("remove-file")
            removeBtn.textContent = "×"
            removeBtn.dataset.index = index
            removeBtn.addEventListener("click", (e) => {
                this.removeFile(parseInt(e.target.dataset.index))
            })

            previewItem.appendChild(removeBtn)
            this.previewTarget.appendChild(previewItem)
        })
    }

    upload() {
        if (this.files.length === 0) {
            alert("Please select at least one file")
            return
        }

        const formData = new FormData()

        this.files.forEach(file => {
            formData.append(`${this.paramValue || 'document[files][]'}`, file)
        })

        // Show progress if we have a progress target
        if (this.hasProgressTarget) {
            this.progressTarget.classList.remove("hidden")
            this.progressTarget.value = 0
        }

        // Disable upload button during upload if needed
        const uploadButton = this.element.querySelector('[data-action*="file-upload#upload"]')
        if (uploadButton) uploadButton.disabled = true

        fetch(this.urlValue, {
            method: "POST",
            body: formData,
            credentials: "same-origin",
            headers: {
                "X-CSRF-Token": this.getMetaValue("csrf-token")
            }
        })
            .then(response => {
                if (!response.ok) throw new Error("Network response was not ok")
                return response.json()
            })
            .then(data => {
                this.reset()
            })
            .catch(error => {
                console.error("Upload failed:", error)
            })
            .finally(() => {
                if (this.hasProgressTarget) {
                    this.progressTarget.classList.add("hidden")
                }
                if (uploadButton) uploadButton.disabled = false
            })
    }

    removeFile(index) {
        this.files = this.files.filter((_, i) => i !== index)
        this.updatePreviews()
    }

    // Add this method to reset state when starting a new upload
    reset() {
        this.fileInputTarget.value = '' // Clear the file input
        const uploadPreview = document.getElementById('upload-preview')
        if (uploadPreview) {
            uploadPreview.innerHTML = ''
        }
    }
}
