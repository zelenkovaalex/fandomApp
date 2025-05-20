document.addEventListener('ajax:success', function (event) {
  const [data, _status, xhr] = event.detail;
  const button = event.target.closest('.like-button');
  const heartImage = button.querySelector('img');

  if (data.success) {
    if (data.liked) {
      heartImage.setAttribute('src', '/assets/atoms/Default.svg'); // Заполненное сердце
    } else {
      heartImage.setAttribute('src', '/assets/atoms/Selected.svg'); // Контур сердца
    }
  } else {
    alert('Ошибка при отправке лайка');
  }
});

document.addEventListener('ajax:error', function (event) {
  alert('Произошла ошибка при отправке запроса');
});