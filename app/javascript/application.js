// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('turbolinks:load', () => {
  const splashScreen = document.querySelector('.splash-container');

  // Optional: Auto-redirect after a few seconds
  setTimeout(() => {
    window.location.href = '/home';
  }, 3000);
});
import "channels"
