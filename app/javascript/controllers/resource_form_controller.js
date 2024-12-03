import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submitForm(event) {
    event.preventDefault() // Prevent the default form submission

    // Example: Accessing target values
    console.log('Name:', this.nameTarget.value)
    console.log('Quantity:', this.quantityTarget.value)

    // Submit the form via AJAX or Turbo
    fetch(this.element.action, {
      method: this.element.method,
      body: new FormData(this.element),
      headers: {
        'X-Requested-With': 'XMLHttpRequest'
      }
    })
    .then(response => response.json())
    .then(data => {
      // Handle the response
      console.log('Form submitted successfully:', data)
    })
    .catch(error => {
      console.error('Error submitting form:', error)
    })
  }
}