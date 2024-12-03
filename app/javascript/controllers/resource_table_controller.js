import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "tableBody", "modalBackdrop", "modalContent"]

  connect() {
    this.closeModal()
  }

  openShowModal(event) {
    event.preventDefault()
    const resourceId = event.currentTarget.dataset.resourceId
    this.openModal(`/${this.resourcePath}/${resourceId}`)
  }

  openEditModal(event) {
    event.preventDefault()
    const resourceId = event.currentTarget.dataset.resourceId
    this.openModal(`/${this.resourcePath}/${resourceId}/edit`)
  }

  openNewModal(event) {
    event.preventDefault()
    this.openModal(`/${this.resourcePath}/new`)
  }

  openModal(url) {
    const frame = document.getElementById('modal_content');

    // If the modal content doesn't exist, create it
    if (!frame) {
      const newFrame = document.createElement('turbo-frame');
      newFrame.id = 'modal_content';
      document.body.appendChild(newFrame);
    }
  
    // Replace the modal content by setting the Turbo Frame's src
    const newFrame = document.createElement('turbo-frame');
    newFrame.id = 'modal_content';
    newFrame.src = url;
  
    frame.replaceWith(newFrame); // Replace the old content with the new Turbo Frame
    this.modalBackdropTarget.classList.remove('hidden'); // Show the modal backdrop
  }

  closeModal() {
    this.modalBackdropTarget.classList.add('hidden')
    setTimeout(() => {
      const frame = document.getElementById('modal_content')
      if (frame) {
        const newFrame = document.createElement('turbo-frame')
        newFrame.id = 'modal_content'
        frame.replaceWith(newFrame)
      }
    }, 150)
  }

  stopPropagation(event) {
    event.stopPropagation()
  }

  search() {
    const query = this.searchInputTarget.value.toLowerCase()
    const rows = this.tableBodyTarget.querySelectorAll(".resource-row")
    
    rows.forEach(row => {
      const text = row.textContent.toLowerCase()
      row.classList.toggle("hidden", !text.includes(query))
    })
  }

  get resourcePath() {
    return window.location.pathname.split('/')[1]
  }
}