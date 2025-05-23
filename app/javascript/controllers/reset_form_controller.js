import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    reset() {
            if (this.element.dataset.success === "true") {
      this.element.reset();
            }
    }
}