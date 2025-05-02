import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "input", "progress", "error", "avatar" ]
    static values = {
        uploadPath: String,
        maxFileSize: { type: Number, default: 5 }, // MB
        acceptedTypes: { type: Array, default: ['image/jpeg', 'image/png'] }
    }

    connect() {
        console.log('Avatar upload controller connected');
        this.resetProgress()
    }

    validateFile(file) {
        // Check file type
        if (!this.acceptedTypesValue.includes(file.type)) {
            this.showError("File type not supported. Please upload a JPEG, PNG")
            return false
        }

        // Check file size (convert MB to bytes)
        if (file.size > this.maxFileSizeValue * 1024 * 1024) {
            this.showError(`File size should be less than ${this.maxFileSizeValue}MB.`)
            return false
        }

        this.errorTarget.textContent = ""
        this.errorTarget.classList.add("hidden")
        return true
    }

    uploadFile(event) {
        event.preventDefault();
        const file = this.inputTarget.files[0];
        if (!file || !this.validateFile(file)) return;

        const formData = new FormData();
        formData.append('user[avatar]', file);

        const token = document.querySelector('meta[name="csrf-token"]').content;

        this.startProgress()

        fetch(this.uploadPathValue, {
            method: 'PATCH',
            headers: {
                'X-CSRF-Token': token
            },
            body: formData,
            credentials: 'same-origin'
        })
            .then(response => {
                if (!response.ok) throw new Error('Upload failed')
                return response.json()
            })
            .then(data => {
                this.completeProgress();
                // Set the avatar url from the response if provided
                if (data.avatar_url) {
                    console.log(data.avatar_url);
                    this.avatarTarget.src = data.avatar_url;
                }
            })
            .catch(error => {
                this.showError("Upload failed: " + error.message)
                this.resetProgress()
            })
    }

    startProgress() {
        this.progressTarget.classList.remove("hidden")
        this.progressTarget.value = 0
        this.progressTarget.max = 100

        this.progressInterval = setInterval(() => {
            const currentValue = this.progressTarget.value
            if (currentValue < 90) {
                this.progressTarget.value = currentValue + 10
            }
        }, 300)
    }

    completeProgress() {
        clearInterval(this.progressInterval)
        this.progressTarget.value = 100

        // Hide progress after a bit
        setTimeout(() => {
            this.resetProgress()
        }, 1000)
    }

    resetProgress() {
        if (this.progressInterval) clearInterval(this.progressInterval)
        this.progressTarget.classList.add("hidden")
    }

    showError(message) {
        this.errorTarget.textContent = message
        this.errorTarget.classList.remove("hidden")
    }
}