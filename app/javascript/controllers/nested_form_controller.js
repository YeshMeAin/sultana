import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["template", "fields"]

  connect() {
    this.fieldsTarget.querySelectorAll('select').forEach(select => {
      select.addEventListener('change', this.updatePrice.bind(this))
      this.setInitialPrice(select)
    })
  }

  setInitialPrice(select) {
    const priceField = select.closest('.menu-item-fields').querySelector('input[name*="[price]"]')
    if (priceField && !priceField.value) {
      this.updatePrice({ target: select })
    }
  }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    this.fieldsTarget.insertAdjacentHTML('beforeend', content)
    const newSelect = this.fieldsTarget.lastElementChild.querySelector('select')
    newSelect.addEventListener('change', this.updatePrice.bind(this))
  }

  remove(event) {
    event.preventDefault()
    const wrapper = event.target.closest('.nested-fields')
    if (wrapper.dataset.newRecord == "true") {
      wrapper.remove()
    } else {
      wrapper.style.display = 'none'
      wrapper.querySelector("input[name*='_destroy']").value = 1
    }
  }

  updatePrice(event) {
    const select = event.target
    const prices = JSON.parse(select.dataset.prices)
    const selectedItemId = select.value
    const price = prices[selectedItemId] || 0
    const priceField = select.closest('.menu-item-fields').querySelector('input[name*="[price]"]')
    if (priceField) {
      priceField.value = price
    }
  }
}
