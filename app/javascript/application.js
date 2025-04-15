// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("turbolinks:load", () => {
  setTimeout(() => {
    window.location.href = "/home";
  }, 3000);
});
import "channels";

addEventListener("direct-upload:initialize", (event) => {
  const { target, detail } = event;
  const { id, file } = detail;
  target.insertAdjacentHTML(
    "beforebegin",
    `
    <div id="direct-upload-${id}" class="direct-upload direct-upload--pending">
      <div id="direct-upload-progress-${id}" class="direct-upload__progress" style="width: 0%"></div>
      <span class="direct-upload__filename"></span>
    </div>
  `,
  );
  target.previousElementSibling.querySelector(
    `.direct-upload__filename`,
  ).textContent = file.name;
});

addEventListener("direct-upload:start", (event) => {
  const { id } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.remove("direct-upload--pending");
});

addEventListener("direct-upload:progress", (event) => {
  const { id, progress } = event.detail;
  const progressElement = document.getElementById(
    `direct-upload-progress-${id}`,
  );
  progressElement.style.width = `${progress}%`;
});

addEventListener("direct-upload:error", (event) => {
  event.preventDefault();
  const { id, error } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.add("direct-upload--error");
  element.setAttribute("title", error);
});

addEventListener("direct-upload:end", (event) => {
  const { id } = event.detail;
  const element = document.getElementById(`direct-upload-${id}`);
  element.classList.add("direct-upload--complete");
});

document.addEventListener("DOMContentLoaded", function () {
  const bioField = document.querySelector('textarea[name="user[bio]"]');
  const bioCount = document.getElementById("bio-count");

  if (bioField && bioCount) {
    bioCount.textContent = bioField.value.length;

    bioField.addEventListener("input", function () {
      bioCount.textContent = this.value.length;
    });
  }
});

document.addEventListener("turbo:load", () => {
  // Handle flash messages that might be in the body after a Turbo visit
  const flashMessages = document.querySelectorAll(".alert");
  flashMessages.forEach((element) => {
    // Display the message (use your toast library here if applicable)
    console.log("Flash message found:", element.textContent);
  });
});

let isScrollingDown = null;
let lastScrollPosition = window.scrollY;

document.addEventListener("turbo:load", () => {
  const dynamicElement = document.getElementById("dynamic-height-element");
  if (!dynamicElement) return;

  const postsElement = document.getElementById("posts");
  let lastScrollTop = postsElement.scrollTop;

  postsElement.addEventListener("scroll", () => {
    let dynamicElementHeight = document.getElementById(
      "dynamic-height-element",
    );
    if (postsElement.scrollTop > lastScrollTop) {
      dynamicElementHeight.classList.add("opacity-0");
      dynamicElementHeight.classList.add("-translate-y-4");
      dynamicElementHeight.classList.remove("opacity-100");
      dynamicElementHeight.classList.remove("translate-y-0");
      dynamicElementHeight.classList.add("h-0");
    } else {
      if (postsElement.scrollTop == 0) {
        dynamicElementHeight.classList.add("opacity-100");
        dynamicElementHeight.classList.add("translate-y-0");
        dynamicElementHeight.classList.remove("opacity-0");
        dynamicElementHeight.classList.remove("-translate-y-4");
        dynamicElementHeight.classList.remove("h-0");
      }
    }

    lastScrollTop = postsElement.scrollTop;
  });
});
