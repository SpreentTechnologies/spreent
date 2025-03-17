import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["tab", "content"]

    connect() {
        // Activate the first tab by default
        this.tabTargets[0].classList.add('active')
        this.contentTargets[0].classList.add('active')
    }

    switch(event) {
        const selectedTab = event.currentTarget
        const tabName = selectedTab.dataset.tab

        // Update active tab
        this.tabTargets.forEach(tab => {
            tab.classList.toggle('active', tab === selectedTab)
        })

        // Show relevant content
        this.contentTargets.forEach(content => {
            content.classList.toggle('active', content.dataset.tab === tabName)
        })
    }
}