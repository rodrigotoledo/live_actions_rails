import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { debounce: { type: Number, default: 300 } }

  timeout = null

  perform() {
    clearTimeout(this.timeout)

    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, this.debounceValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
