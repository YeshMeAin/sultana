import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["frame"]

  connect() {
    // You can add dynamic frame behavior here
    // For example, loading different patterns or adjusting the frame size
  }

  // Example method to change the pattern
  changePattern(pattern) {
    this.frameTarget.style.borderImage = `url(${pattern}) 40 repeat`
  }
}