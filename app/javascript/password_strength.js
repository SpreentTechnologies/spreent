import { default as zxcvbn } from "zxcvbn"

export default class PasswordStrengthMeter {
    constructor() {
        this.passwordField = document.querySelector('#user_password');

        if (!this.passwordField) return;

        this.createMeterElements();
        this.bindEvents();
    }

    createMeterElements() {
        // Create meter container
        this.meterContainer = document.createElement('div');
        this.meterContainer.className = 'password-strength-meter';
        this.meterContainer.innerHTML = `
      <div class="meter-bar">
        <div class="meter-fill"></div>
      </div>
      <div class="meter-text"></div>
    `;

        // Insert after password field
        this.passwordField.parentNode.insertBefore(
            this.meterContainer,
            this.passwordField.nextSibling
        );

        this.meterFill = this.meterContainer.querySelector('.meter-fill');
        this.meterText = this.meterContainer.querySelector('.meter-text');

        // Initially hide the meter
        this.meterContainer.style.display = 'none';
    }

    bindEvents() {
        this.passwordField.addEventListener('input', this.updateStrengthMeter.bind(this));
    }

    updateStrengthMeter() {
        const password = this.passwordField.value;

        if (password === '') {
            this.meterContainer.style.display = 'none';
            return;
        }

        this.meterContainer.style.display = 'block';

        // Calculate password strength
        const result = zxcvbn(password);
        const score = result.score;

        // Define colors and labels for each score
        const colors = ['#F25F5C', '#FFE066', '#70C1B3', '#247BA0', '#247BA0'];
        const labels = ['Very weak', 'Weak', 'Fair', 'Strong', 'Very strong'];

        // Set width percentage based on score (0-4)
        const width = (score + 1) * 20;
        this.meterFill.style.width = `${width}%`;
        this.meterFill.style.backgroundColor = colors[score];

        // Set text feedback
        this.meterText.innerHTML = labels[score];

        // Add suggestions if available
        if (result.feedback.suggestions.length > 0) {
            const suggestion = document.createElement('div');
            suggestion.className = 'meter-suggestion';
            suggestion.textContent = result.feedback.suggestions[0];
            this.meterText.appendChild(suggestion);
        }
    }
}
