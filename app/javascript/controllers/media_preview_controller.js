import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "preview" ]

  connect() {
    this.previewContainer = document.getElementById('media-preview')
  }

  handleFiles(event) {
    const files = event.target.files
    this.previewContainer.innerHTML = '' // Clear previous previews

    Array.from(files).forEach(file => {
      const reader = new FileReader()

      reader.onload = (e) => {
        const mediaElement = this.createMediaElement(file, e.target.result)
        this.previewContainer.appendChild(mediaElement)
      }

      if (file.type.startsWith('image/')) {
        reader.readAsDataURL(file)
      } else if (file.type.startsWith('video/')) {
        reader.readAsDataURL(file)
      }
    })
  }

  createMediaElement(file, src) {
    const container = document.createElement('div')
    container.className = 'media-item'

    if (file.type.startsWith('image/')) {
      const img = document.createElement('img')
      img.src = src
      img.className = 'preview-image'
      container.appendChild(img)
    } else if (file.type.startsWith('video/')) {
      const video = document.createElement('video')
      video.src = src
      video.className = 'preview-video'
      video.controls = true
      container.appendChild(video)
    }

    return container
  }
}
