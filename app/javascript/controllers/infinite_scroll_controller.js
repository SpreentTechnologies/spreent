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


        this.containerTarget.addEventListener('scroll', this.handleScroll.bind(this), {
            passive: true
        });


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


        if (scrollHeight - scrollTop === clientHeight) {
            this.loadMore();
        }
        this.lastScrollTop = scrollTop
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
                this.containerTarget.insertAdjacentHTML("beforeend", "<div data-infinite-scroll-target='scrollTrigger' class='h-11'></div>");
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