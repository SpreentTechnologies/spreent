import { Controller } from "@hotwired/stimulus"
import zxcvbn from "zxcvbn"

// Connects to data-controller="password-strength"
export default class extends Controller {
    static targets = ["password", "meter", "meterFill", "meterText"]

    connect() {
        // If the password field doesn't have the target attribute, find it manually
        if (!this.hasPasswordTarget) {
            this.passwordElement = this.element.querySelector('#user_password');
        } else {
            this.passwordElement = this.passwordTarget;
        }

        if (!this.passwordElement) return;

        // Create meter if it doesn't exist as a target
        if (!this.hasMeterTarget) {
            this.createMeterElements();
        }

        // Hide meter initially
        this.meterElement.style.display = 'none';
    }

    createMeterElements() {
        // Create meter container
        this.meterElement = document.createElement('div');
        this.meterElement.className = 'password-strength-meter';
        this.meterElement.setAttribute('data-password-strength-target', 'meter');
        this.meterElement.innerHTML = `
      <div class="meter-bar">
        <div class="meter-fill" data-password-strength-target="meterFill"></div>
      </div>
      <div class="meter-text" data-password-strength-target="meterText"></div>
    `;

        // Insert after password field
        this.passwordElement.parentNode.insertBefore(
            this.meterElement,
            this.passwordElement.nextSibling
        );

        this.meterFillElement = this.meterElement.querySelector('.meter-fill');
        this.meterTextElement = this.meterElement.querySelector('.meter-text');
    }

    updateStrength() {
        const password = this.passwordElement.value;

        if (password === '') {
            this.meterElement.style.display = 'none';
            return;
        }

        this.meterElement.style.display = 'block';

        // Calculate password strength
        const result = zxcvbn(password);
        const score = result.score;

        // Define colors and labels for each score
        const colors = ['#F25F5C', '#FFE066', '#70C1B3', '#247BA0', '#247BA0'];
        const labels = ['Very weak', 'Weak', 'Fair', 'Strong', 'Very strong'];

        // Set width percentage based on score (0-4)
        const width = (score + 1) * 20;
        this.meterFillElement.style.width = `${width}%`;
        this.meterFillElement.style.backgroundColor = colors[score];

        // Set text feedback
        this.meterTextElement.innerHTML = labels[score];

        // Add suggestions if available
        if (result.feedback.suggestions.length > 0) {
            const suggestion = document.createElement('div');
            suggestion.className = 'meter-suggestion';
            suggestion.textContent = result.feedback.suggestions[0];
            this.meterTextElement.appendChild(suggestion);
        }
    }
}