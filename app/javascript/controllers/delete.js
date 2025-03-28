document.addEventListener('DOMContentLoaded', function () {
  const deleteButtons = document.querySelectorAll('.custom-delete-button');

  deleteButtons.forEach(button => {
    button.addEventListener('click', function () {
      const url = this.dataset.url; // URL будет храниться в data-url
      if (!url) return;

      fetch(url, {
        method: 'DELETE',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
        },
      })
        .then(response => {
          if (response.ok) {
            // Успешное удаление
            alert('Объект успешно удален');
            // Здесь можно добавить логику для обновления страницы или удаления элемента
          } else {
            // Ошибка при удалении
            alert('Ошибка при удалении объекта');
          }
        })
        .catch(error => {
          console.error('Ошибка:', error);
        });
    });
  });
});