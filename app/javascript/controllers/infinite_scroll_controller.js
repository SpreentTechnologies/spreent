import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "scrollTrigger", "loadingIndicator", "noMorePosts"]
    static values = {
        atBottom: Boolean,
        bottomThreshold: { type: Number, default: 5 }
    }

    connect() {
        this.page = 1
        this.loading = false
        this.lastPage = false

        this.containerTarget.addEventListener('scroll', this.handleScroll.bind(this))
    }

    disconnect() {
    }

    handleScroll() {
        // Check if we're near the bottom of the page
        const container = this.containerTarget
        const isAtBottom = container.scrollTop + container.clientHeight >=
            container.scrollHeight - this.bottomThresholdValue

        if (isAtBottom !== this.atBottomValue) {
            this.atBottomValue = isAtBottom

            if (isAtBottom) {
                this.loadMore();
            }
        }
    }

    handleIntersection(entries) {
        entries.forEach(entry => {
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