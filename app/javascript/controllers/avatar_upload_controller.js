import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = [ "input", "progress", "error" ]
    static values = {
        uploadPath: String,
        maxFileSize: { type: Number, default: 5 }, // MB
        acceptedTypes: { type: Array, default: ['image/jpeg', 'image/png'] }
    }

    connect() {
        console.log('Avatar upload controller connected');
    }

    uploadFile(event) {
        event.preventDefault();
        const file = this.inputTarget.files[0];
        if (!file) return;
        console.log(file);

        const formData = new FormData();
        formData.append('user[avatar]', file);

        const token = document.querySelector('meta[name="csrf-token"]').content;

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
                // Set the avatar url from the response if provided
                if (data.avatar_url) {
                    console.log(data.avatar_url);
                }
            })
            .catch(error => {
                console.log("Upload failed: " + error.message)
            })
    }
}