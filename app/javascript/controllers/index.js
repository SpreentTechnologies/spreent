// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

document.addEventListener("turbo:before-stream-render", (event) => {
    if (event.target.action === "modal") {
        event.preventDefault()
        const controller = application.getControllerForElementAndIdentifier(
            document.getElementById("modal"),
            "modal"
        )
        if (controller) {
            controller.open()
        }
    }
})

document.addEventListener('turbo:load', showFlashMessages);