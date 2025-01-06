import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["ctaButton"]

  connect() {
    this.updateCTA()
  }

  updateCTA() {
    const status = this.element.dataset.status
    let action, path

    switch (status) {
      case 'pending':
        action = 'Confirm'
        path = `/orders/${this.element.dataset.orderId}/confirm`
        break
      case 'confirmed':
        action = 'Prepare'
        path = `/orders/${this.element.dataset.orderId}/prepare`
        break
      case 'preparing':
        action = 'Ready'
        path = `/orders/${this.element.dataset.orderId}/ready`
        break
      case 'ready':
        action = 'Deliver'
        path = `/orders/${this.element.dataset.orderId}/deliver`
        break
      case 'delivered':
        action = 'Paid'
        path = `/orders/${this.element.dataset.orderId}/pay`
        break
      default:
        action = null
    }

    if (action) {
      this.ctaButtonTarget.textContent = action
      this.ctaButtonTarget.dataset.path = path
      this.ctaButtonTarget.classList.remove('hidden')
    } else {
      this.ctaButtonTarget.classList.add('hidden')
    }
  }

  performAction(event) {
    event.preventDefault()
    const path = event.currentTarget.dataset.path

    fetch(path, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        'Content-Type': 'application/json'
      }
    }).then(response => {
      if (response.ok) {
        // Refresh the table or the specific row
        window.location.reload()
      }
    })
  }
} 