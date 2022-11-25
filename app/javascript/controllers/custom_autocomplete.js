import { Autocomplete } from "stimulus-autocomplete"

export default class CustomAutocomplete extends Autocomplete {
  connect() {
    super.connect()
    this.bindFormSubmitOnValueChange(this.element)
    this.bindFocusInputOnKeydown(this.element.children[0])
  }

  bindFormSubmitOnValueChange(autocompleteWrapper) {
    const form = autocompleteWrapper.parentElement;
    autocompleteWrapper.addEventListener("autocomplete.change", (event) => {
      form.submit()
    })
  }

  bindFocusInputOnKeydown(textInput) {
    document.addEventListener("keydown", function(e) {
      if ((window.navigator.platform.match("Mac") ? e.metaKey : e.ctrlKey)  && e.keyCode == 70) {
        e.preventDefault();
        const valueLength = textInput.value.length
        textInput.setSelectionRange(valueLength, valueLength);
        textInput.focus()
      }
    }, false);
  }
}