import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "sidebar", "overlay" ]

  connect() {
    this.handleEscape = this.handleEscape.bind(this)
    document.addEventListener("keydown", this.handleEscape)
  }

  disconnect() {
    document.removeEventListener("keydown", this.handleEscape)
  }

  toggle() {
    this.isOpen ? this.close() : this.open()
  }

  open() {
    this.sidebarTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.sidebarTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")
  }

  handleEscape(event) {
    if (event.key === "Escape") this.close()
  }

  get isOpen() {
    return !this.sidebarTarget.classList.contains("-translate-x-full")
  }
}
