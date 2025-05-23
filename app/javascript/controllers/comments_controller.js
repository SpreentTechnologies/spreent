import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        // Disable scrolling when the panel is open
        document.body.classList.add('no-scroll');

        this.createOverlay();


        // Animation to slide in the panel
        const panel = document.getElementById('comments_panel');
        panel.classList.add('fixed', 'bottom-[57px]', 'left-[0]', 'w-full', 'bg-white', 'translate-y-0', 'transition-all', 'duration-500', 'ease-out', 'z-50', 'max-h-72', 'overflow-y-auto');

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

        createOverlay() {
        // Create overlay element
        this.overlay = document.createElement('div');
        this.overlay.id = 'comments-overlay';
        this.overlay.className = 'fixed inset-0 bg-black bg-opacity-50 z-40 transition-opacity duration-300 ease-out';
        
        // Start with opacity 0 for fade-in animation
        this.overlay.style.opacity = '0';
        
        // Add click listener to close when clicking overlay
        this.overlay.addEventListener('click', (event) => {
            if (event.target === this.overlay) {
                this.close();
            }
        });
        
        // Append to body
        document.body.appendChild(this.overlay);
        
        // Trigger fade-in animation
        requestAnimationFrame(() => {
            this.overlay.style.opacity = '1';
        });
    }

        removeOverlay() {
        if (this.overlay && this.overlay.parentNode) {
            // Fade out animation
            this.overlay.style.opacity = '0';
            
            // Remove after animation completes
            setTimeout(() => {
                if (this.overlay && this.overlay.parentNode) {
                    this.overlay.parentNode.removeChild(this.overlay);
                }
            }, 300);
        }
    }

    close(event) {
        const commentsPanel = document.getElementById('comments_panel');
        // Don't close if clicking inside the panel (only on overlay or close button)
        if (event && commentsPanel &&
            !event.target.closest('[data-action*="comments#close"]')) {
            return;
        }

        // Animation to slide out
        commentsPanel.classList.remove('absolute', 'bottom-[55px]', 'left-[0]', 'w-full', 'bg-white', 'translate-y-50', 'transition-all', 'duration-500', 'ease-out');

        // Remove overlay
        this.removeOverlay();
        
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