import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source", "copyLabel"]

  async copy() {
    const text = this.sourceTarget.value

    try {
      await navigator.clipboard.writeText(text)
    } catch {
      this.sourceTarget.hidden = false
      this.sourceTarget.select()
      document.execCommand("copy")
      this.sourceTarget.hidden = true
    }

    const label = this.copyLabelTarget
    label.textContent = "Tersalin!"
    clearTimeout(this.restoreTimer)
    this.restoreTimer = setTimeout(() => {
      label.textContent = "Salin teks"
    }, 2000)
  }

  disconnect() {
    clearTimeout(this.restoreTimer)
  }
}
