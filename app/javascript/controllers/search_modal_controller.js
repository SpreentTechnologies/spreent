import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["content"]

    connect() {
        // Set up the user filter on page load
        const userSearch = document.getElementById('user-search')
        if (userSearch) {
            userSearch.addEventListener('input', this.filterUsers)
        }

        // Handle user selection
        const userItems = document.querySelectorAll('.user-item')
        userItems.forEach(item => {
            item.addEventListener('click', () => {
                // Select the radio button
                const radio = item.querySelector('input[type="radio"]')
                radio.checked = true

                // Add visual indicator for selected user
                userItems.forEach(i => i.classList.remove('bg-gray-100'))
                item.classList.add('bg-gray-100')
            })
        })
    }

    open() {
        const modal = document.getElementById('new-conversation-modal')
        modal.classList.remove('hidden')

        // Focus the search input
        setTimeout(() => {
            document.getElementById('user-search').focus()
        }, 100)
    }

    close() {
        const modal = document.getElementById('new-conversation-modal')
        modal.classList.add('hidden')

        // Reset the filter
        document.getElementById('user-search').value = ''
        this.filterUsers({ target: { value: '' } })
    }

    clickOutside(event) {
        if (this.contentTarget && !this.contentTarget.contains(event.target)) {
            this.close()
        }
    }

    closeOnEscape(event) {
        if (event.key === 'Escape') {
            this.close()
        }
    }

    filterUsers(event) {
        const query = event.target.value.toLowerCase()
        const userItems = document.querySelectorAll('.user-item')

        userItems.forEach(item => {
            const username = item.dataset.username
            if (username.includes(query)) {
                item.classList.remove('hidden')
            } else {
                item.classList.add('hidden')
            }
        })
    }
}