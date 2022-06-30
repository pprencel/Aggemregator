import { Application } from "@hotwired/stimulus"
import { CustomAutocomplete } from "./custom_autocomplete"

const application = Application.start()

application.register('autocomplete', CustomAutocomplete)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
