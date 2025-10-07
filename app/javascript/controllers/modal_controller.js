import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]

  close(event) {
    if (event.target.dataset.action === "modal#close") {
      this.element.remove()
    }
  }
}
