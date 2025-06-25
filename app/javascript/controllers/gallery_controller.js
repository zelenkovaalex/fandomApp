import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["indicator", "carousel"]

  connect() {
    this.indicators = this.indicatorTargets
    this.carousel = this.carouselTarget

    this.indicators.forEach((indicator) => {
      indicator.addEventListener("click", () => {
        const index = parseInt(indicator.getAttribute("data-index"))
        const target = this.carousel.children[index]
        if (target) {
          target.scrollIntoView({ behavior: "smooth", inline: "center" })
        }
        this.updateActiveIndicator(index)
      })
    })

    this.carousel.addEventListener("scroll", () => this.onScroll())
  }

  updateActiveIndicator(index) {
    this.indicators.forEach((i, idx) => i.classList.toggle("active", idx === index))
  }

  onScroll() {
    const midpoint = window.innerWidth / 2
    let closestIndex = 0
    let minDistance = Infinity

    Array.from(this.carousel.children).forEach((item, index) => {
      const rect = item.getBoundingClientRect()
      const distance = Math.abs(rect.left + rect.width / 2 - midpoint)
      if (distance < minDistance) {
        minDistance = distance
        closestIndex = index
      }
            })
  this.updateActiveIndicator(closestIndex)
  }
}