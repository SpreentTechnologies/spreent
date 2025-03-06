import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        // Disable scrolling when the panel is open
        document.body.classList.add('no-scroll');

        // Animation to slide in the panel
        const panel = this.element.querySelector('.comments-panel');
        panel.classList.add('slide-in');

        // Add event listener for ESC key
        this.handleKeyDown = this.handleKeyDown.bind(this);
        document.addEventListener('keydown', this.handleKeyDown);

        // For drag gesture
        this.isDragging = false;
        this.startY = 0;
        this.currentY = 0;
    }

    disconnect() {
        document.removeEventListener('keydown', this.handleKeyDown);
        this.removeDragListeners();
    }

    close(event) {
        console.log('close!');
        // Don't close if clicking inside the panel (only on overlay or close button)
        if (event && event.target.closest('.comments-panel') &&
            !event.target.closest('[data-action*="comments#close"]')) {
            return;
        }

        // Animation to slide out
        const panel = this.element.querySelector('.comments-panel');
        panel.classList.remove('slide-in');

        // Re-enable scrolling
        document.body.classList.remove('no-scroll');

        // Wait for animation to finish then remove the frame
        setTimeout(() => {
            this.element.innerHTML = '';
        }, 300);
    }

    handleKeyDown(event) {
        if (event.key === 'Escape') {
            this.close();
        }
    }

    // Dragging functionality for mobile
    startDrag(event) {
        this.isDragging = true;

        // Determine starting point based on event type (mouse or touch)
        this.startY = event.type === 'touchstart'
            ? event.touches[0].clientY
            : event.clientY;

        // Add event listeners for dragging
        document.addEventListener('mousemove', this.dragMove.bind(this));
        document.addEventListener('touchmove', this.dragMove.bind(this), { passive: false });
        document.addEventListener('mouseup', this.dragEnd.bind(this));
        document.addEventListener('touchend', this.dragEnd.bind(this));

        // Disable transition during dragging
        const panel = this.element.querySelector('.comments-panel');
        panel.style.transition = 'none';
    }

    dragMove(event) {
        if (!this.isDragging) return;

        // Prevent default only for touch events to avoid scrolling
        if (event.type === 'touchmove') {
            event.preventDefault();
        }

        // Get current Y position
        this.currentY = event.type === 'touchmove'
            ? event.touches[0].clientY
            : event.clientY;

        // Calculate how far we've dragged
        const dragDistance = this.currentY - this.startY;

        // Only allow dragging downwards
        if (dragDistance > 0) {
            const panel = this.element.querySelector('.comments-panel');
            panel.style.transform = `translateY(${dragDistance}px)`;
        }
    }

    dragEnd(event) {
        if (!this.isDragging) return;

        this.isDragging = false;
        this.removeDragListeners();

        const panel = this.element.querySelector('.comments-panel');
        panel.style.transition = 'transform 0.3s ease';

        // Calculate how far we've dragged
        const dragDistance = this.currentY - this.startY;
        const threshold = panel.offsetHeight * 0.3; // 30% of panel height

        // If dragged more than threshold, close the panel
        if (dragDistance > threshold) {
            this.close();
        } else {
            // Otherwise snap back
            panel.style.transform = '';
        }
    }

    removeDragListeners() {
        document.removeEventListener('mousemove', this.dragMove.bind(this));
        document.removeEventListener('touchmove', this.dragMove.bind(this));
        document.removeEventListener('mouseup', this.dragEnd.bind(this));
        document.removeEventListener('touchend', this.dragEnd.bind(this));
    }
}