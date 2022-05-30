import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log('cool');
    this.element.textContent = "Hello World!"
  }
}
