document.addEventListener("DOMContentLoaded", function() {
  const carousel = document.querySelector('turbo-frame#carousel');
  if (!carousel) return;

  // Клавиши влево/вправо
  document.addEventListener('keydown', function(e) {
    if (e.key === "ArrowLeft") {
      const prev = carousel.querySelector('.carousel-prev:not([disabled])');
      if (prev) prev.click();
    }
    if (e.key === "ArrowRight") {
      const next = carousel.querySelector('.carousel-next:not([disabled])');
      if (next) next.click();
    }
  });

  // Свайпы (touch)
  let startX = null;
  carousel.addEventListener('touchstart', function(e) {
    startX = e.touches[0].clientX;
  });
  carousel.addEventListener('touchend', function(e) {
    if (startX === null) return;
    let endX = e.changedTouches[0].clientX;
    let diff = endX - startX;
    if (Math.abs(diff) > 50) {
      if (diff > 0) {
        // swipe right
        const prev = carousel.querySelector('.carousel-prev:not([disabled])');
        if (prev) prev.click();
      } else {
        // swipe left
        const next = carousel.querySelector('.carousel-next:not([disabled])');
        if (next) next.click();
      }
    }
    startX = null;
  });
});