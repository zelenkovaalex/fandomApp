document.addEventListener("turbo:load", function () {
  const carousel = document.querySelector("[data-controller='carousel']");
  const items = Array.from(carousel.querySelectorAll("[data-target='carousel.item']"));
  const visibleItemsCount = 4;
  let currentIndex = 0;

  // Функция для показа следующего блока
  function showNextBlock() {
    currentIndex += visibleItemsCount;
    if (currentIndex >= items.length) {
      currentIndex = 0;
    }
    updateCarousel();
  }

  // Функция для показа предыдущего блока
  function showPrevBlock() {
    currentIndex -= visibleItemsCount;
    if (currentIndex < 0) {
      currentIndex = items.length - visibleItemsCount;
    }
    updateCarousel();
  }

  // Функция для обновления видимых элементов
  function updateCarousel() {
    items.forEach((item, index) => {
      item.style.display = index >= currentIndex && index < currentIndex + visibleItemsCount ? "block" : "none";
    });
  }

  // Обработчики событий для кнопок
  carousel.querySelector("[data-action='carousel#next']").addEventListener("click", showNextBlock);
  carousel.querySelector("[data-action='carousel#prev']").addEventListener("click", showPrevBlock);

  // Инициализация
  updateCarousel();
});