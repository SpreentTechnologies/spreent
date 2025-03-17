import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.swiper = new Swiper(".swiper-container", {
      // Swiper configuration options
      pagination: {
        el: ".swiper-pagination",
        dynamicBullets: true,
      },
    });
  }
}
