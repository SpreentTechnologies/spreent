import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "scrollTrigger", "loadingIndicator", "noMorePosts"]
    static values = {
        atBottom: Boolean,
        bottomThreshold: { type: Number, default: 100 }
    }

    connect() {
        console.log("🚀 Controller connected")
        this.page = 1
        this.loading = false
        this.lastPage = false
        this.lastScrollTop = 0

            if ('ontouchstart' in window) {
        let touchScrollTimeout
        
        this.containerTarget.addEventListener('touchmove', () => {
            clearTimeout(touchScrollTimeout)
            touchScrollTimeout = setTimeout(() => {
                // Manually trigger scroll check during touch
                this.handleScroll()
            }, 16) // ~60fps
        }, { passive: true })
    }

        this.containerTarget.addEventListener('scroll', this.handleScroll.bind(this), {
            passive: true
        });

    this.containerTarget.style.webkitOverflowScrolling = 'touch'
    this.containerTarget.style.webkitTransform = 'translateZ(0)'
    this.containerTarget.style.transform = 'translateZ(0)'
    this.containerTarget.style.willChange = 'scroll-position'

        this.setupIntersectionObserver()
    }

        setupIntersectionObserver() {
        if (this.hasScrollTriggerTarget) {
            this.observer = new IntersectionObserver(
                this.handleIntersection.bind(this),
                {
                    root: this.containerTarget,
                    rootMargin: '100px', // Trigger 100px before reaching the element
                    threshold: 0.1
                }
            )
            
            this.observer.observe(this.scrollTriggerTarget)
        }
    }

    disconnect() {
        if (this.observer) {
            this.observer.disconnect()
        }
    }

    handleScroll() {
        const container = this.containerTarget
        const scrollTop = container.scrollTop
        const clientHeight = container.clientHeight
        const scrollHeight = container.scrollHeight
        
        // Calculate how close we are to the bottom
        const distanceFromBottom = scrollHeight - (scrollTop + clientHeight)
        
        // Trigger loading when we're within threshold pixels of bottom
        // AND we're scrolling down (not up)
        const isScrollingDown = scrollTop > this.lastScrollTop
        const isNearBottom = distanceFromBottom <= this.bottomThresholdValue
        
        console.log(isNearBottom);
        if (isNearBottom && isScrollingDown && !this.loading && !this.lastPage) {
            console.log('Triggering load while scrolling down, distance from bottom:', distanceFromBottom)
            this.loadMore()
        }
        
        this.lastScrollTop = scrollTop
    }

    handleIntersection(entries) {
        entries.forEach(entry => {
            console.log('Intersection:', entry.isIntersecting)
            if (entry.isIntersecting && !this.loading && !this.lastPage) {
                this.loadMore()
            }
        })
    }

    loadMore() {
        if (this.loading) return

        this.loading = true
        this.loadingIndicatorTarget.classList.remove("hidden")

        this.page += 1

        fetch(`/feed?page=${this.page}`, {
            headers: {
                Accept: "application/json",
                "X-Requested-With": "XMLHttpRequest"
            }
        })
            .then(response => response.json())
            .then(data => {
                // Add new posts to the container
                this.containerTarget.insertAdjacentHTML("beforeend", data.posts)
                this.lastPage = data.last_page

                if (this.lastPage) {
                    // If it's the last page, hide triggers and show end message
                    this.scrollTriggerTarget.classList.add("hidden")
                    this.loadingIndicatorTarget.classList.add("hidden")
                    this.noMorePostsTarget.classList.remove("hidden")
                }
            })
            .catch(error => {
                console.error("Error loading posts:", error)
            })
            .finally(() => {
                this.loading = false
                if (!this.lastPage) {
                    this.loadingIndicatorTarget.classList.add("hidden")
                }
            })
    }
}