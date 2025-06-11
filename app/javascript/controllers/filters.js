$(document).ready(function() {
  // Инициализация активного фильтра
  $('.filter-group a').on('click', function(e) {
    e.preventDefault();

    // Удалить класс active у всех фильтров
    $('.filter-group a').removeClass('active');

    // Добавить класс active к выбранному фильтру
    $(this).addClass('active');

    // Получить значение фильтра
    const filterValue = $(this).attr('data-filter');

    // Отправить AJAX-запрос для получения отфильтрованных профилей
    $.ajax({
      url: '/profiles/filter',
      method: 'GET',
      data: { filter: filterValue },
      success: function(data) {
        $('#profiles-container').html(data);
      }
    });
  });
});