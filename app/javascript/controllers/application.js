import { Application } from "@hotwired/stimulus"
import { Autocomplete } from "stimulus-autocomplete"

const application = Application.start()

class CustomAutocomplete extends Autocomplete {
  connect() {
    super.connect()
    const form = this.element.parentElement;
    this.element.addEventListener("autocomplete.change", (event) => {
      form.submit()
    })
  }
}

application.register('autocomplete', CustomAutocomplete)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
