import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Load saved state from localStorage if available
    this.loadSavedState()
  }
  
  toggleItem(event) {
    const checkbox = event.target
    const productId = checkbox.dataset.productId
    
    // Update the checked state in our data model
    this.updateItemState(productId, checkbox.checked)
    
    // Save progress automatically
    this.saveProgress()
  }
  
  checkAll() {
    this.element.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
      checkbox.checked = true
      this.updateItemState(checkbox.dataset.productId, true)
    })
    this.saveProgress()
  }
  
  uncheckAll() {
    this.element.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
      checkbox.checked = false
      this.updateItemState(checkbox.dataset.productId, false)
    })
    this.saveProgress()
  }
  
  saveProgress() {
    const state = {}
    this.element.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
      state[checkbox.dataset.productId] = checkbox.checked
    })
    
    localStorage.setItem('groceryListState', JSON.stringify(state))
    
    // Show a brief notification
    this.showNotification("Progress saved")
  }
  
  loadSavedState() {
    const savedState = localStorage.getItem('groceryListState')
    if (savedState) {
      const state = JSON.parse(savedState)
      
      this.element.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
        const productId = checkbox.dataset.productId
        if (state[productId] !== undefined) {
          checkbox.checked = state[productId]
        }
      })
    }
  }
  
  updateItemState(productId, checked) {
    // This method could be extended to update a server-side state if needed
  }
  
  showNotification(message) {
    const notification = document.createElement('div')
    notification.className = 'fixed bottom-4 right-4 bg-green-500 text-white px-4 py-2 rounded shadow-lg transition-opacity duration-500'
    notification.textContent = message
    
    document.body.appendChild(notification)
    
    // Fade out and remove after 2 seconds
    setTimeout(() => {
      notification.style.opacity = '0'
      setTimeout(() => {
        notification.remove()
      }, 500)
    }, 2000)
  }
} 