// app/javascript/controllers/file_upload_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["fileInput", "fileList"]

    connect() {
        this.fileInputTarget.addEventListener('change', this.updateFileList.bind(this))
    }

    triggerFileInput(event) {
        this.fileInputTarget.click()
    }

    updateFileList() {
        const files = this.fileInputTarget.files
        this.fileListTarget.innerHTML = ''

        if (files.length) {
            const list = document.createElement('ul')
            list.className = 'file-list'

            Array.from(files).forEach(file => {
                // const item = document.createElement('li')
                // item.className = 'file-item'
                // item.textContent = file.name
                // list.appendChild(item)
                const reader = new FileReader();

              reader.onload = function (event) {
                const img = document.createElement('img');
                img.src = event.target.result;
                img.style.width = '100%';
                img.style.height = '100%';
                document.getElementById('upload-preview').appendChild(img);
              };

                reader.readAsDataURL(file);
            })

            this.fileListTarget.appendChild(list)
        }
    }
}
