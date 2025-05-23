document.addEventListener("turbolinks:load", function () {
  const tabButtons = document.querySelectorAll(".A_buttonTrails");
  const tabPanes = document.querySelectorAll(".O_trailPoints");

  console.log("Buttons:", tabButtons);
  console.log("Panes:", tabPanes);

  function switchTabs(event) {
    event.preventDefault();

    // Удаляем класс "active" у всех кнопок и панелей
    tabButtons.forEach((button) => button.classList.remove("active"));
    tabPanes.forEach((pane) => pane.classList.remove("active"));

    // Получаем ID панели, на которую нужно переключиться
    const targetTab = event.currentTarget.dataset.tab;
    console.log("Target tab:", targetTab);

    // Добавляем класс "active" к выбранной кнопке и панели
    event.currentTarget.classList.add("active");
    const targetPane = document.getElementById(targetTab);
    console.log("Target pane:", targetPane);
    if (targetPane) {
      targetPane.classList.add("active");
    } else {
      console.error("Pane not found for tab:", targetTab);
    }
  }

  // Привязываем обработчик к каждой кнопке
  tabButtons.forEach((button) => {
    button.addEventListener("click", switchTabs);
  });
});