document.addEventListener("DOMContentLoaded", function () {
  const indicators = document.querySelectorAll(".M_galleryIndicators .indicator");
  const carousel = document.getElementById("galleryCarousel");

  indicators.forEach((indicator) => {
    indicator.addEventListener("click", () => {
      const index = parseInt(indicator.getAttribute("data-index"));
      const target = carousel.children[index];
      if (target) {
        target.scrollIntoView({ behavior: "smooth", inline: "center" });
      }

      // Обновляем активный индикатор
      indicators.forEach((i) => i.classList.remove("active"));
      indicator.classList.add("active");
    });
  });

  // Автоматическое обновление точки при скролле
  carousel.addEventListener("scroll", () => {
    const midpoint = window.innerWidth / 2;
    let closestIndex = 0;
    let minDistance = Infinity;

    Array.from(carousel.children).forEach((item, index) => {
      const rect = item.getBoundingClientRect();
      const distance = Math.abs(rect.left + rect.width / 2 - midpoint);
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = index;
      }
    });

    indicators.forEach((i) => i.classList.remove("active"));
    indicators[closestIndex]?.classList.add("active");
  });
});