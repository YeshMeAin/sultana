import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "tableBody"]

  search() {
    const query = this.searchInputTarget.value.toLowerCase()
    const rows = this.tableBodyTarget.querySelectorAll(".resource-row")
    
    rows.forEach(row => {
      const text = row.textContent.toLowerCase()
      row.classList.toggle("hidden", !text.includes(query))
    })
  }

  openNewModal(event) {
    event.preventDefault()
    // Handle with Turbo
  }

  openShowModal(event) {
    event.preventDefault()
    const resourceId = event.currentTarget.dataset.resourceId
    // Handle with Turbo
  }

  openEditModal(event) {
    event.preventDefault()
    const resourceId = event.currentTarget.dataset.resourceId
    // Handle with Turbo
  }
}