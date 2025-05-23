import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.swiper = new Swiper(".swiper-container", {
      slidesPerView: 1.3,
      spaceBetween: 1,
      // Swiper configuration options
      pagination: {
        el: ".swiper-pagination",
        dynamicBullets: true,
      },
    });
  }
}
