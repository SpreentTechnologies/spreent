import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    autoGenerate() {
        const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
        const codeLength = 8
        let result = ''

        for (let i = 0; i < codeLength; i++) {
            result += characters.charAt(Math.floor(Math.random() * characters.length))
        }

        this.element.querySelector('input[name="invitation_code[code]"]').value = result
    }
}