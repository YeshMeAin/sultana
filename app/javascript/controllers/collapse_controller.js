import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]

  connect() {
    this.expanded = false
    this.element.setAttribute("aria-expanded", "false")
    this.contentTarget.classList.add("menu-section__collapsible-list--collapsed")
  }

  toggle() {
    this.expanded = !this.expanded

    if (this.expanded) {
      this.contentTarget.classList.remove("menu-section__collapsible-list--collapsed")
      this.contentTarget.classList.add("menu-section__collapsible-list--expanded")
    } else {
      this.contentTarget.classList.remove("menu-section__collapsible-list--expanded")
      this.contentTarget.classList.add("menu-section__collapsible-list--collapsed")
    }

    this.iconTarget.style.transform = this.expanded ? "rotate(0deg)" : "rotate(-180deg)"
    this.element.setAttribute("aria-expanded", this.expanded)
  }
} 