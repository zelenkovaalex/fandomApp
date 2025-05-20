document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('add-trail-point').addEventListener('click', function() {
    const container = document.querySelector('.W_inputs');
    const index = container.querySelectorAll('.trail-point').length;
    const newPointHTML = `
      <div class="trail-point">
        <span class="step-number">Точка ${index + 1}</span>
        <div class="A_input">
          <p>Фото</p>
          <input type="file" name="trail[trail_points_attributes][${index}][image_url]" required>
        </div>
        <div class="A_input">
          <p>Название</p>
          <input type="text" name="trail[trail_points_attributes][${index}][name]" required>
        </div>
        <div class="A_input">
          <p>Описание</p>
          <textarea name="trail[trail_points_attributes][${index}][description]" style="height: 10vw;" required></textarea>
        </div>
        <div class="A_input">
          <p>Ссылка на карту</p>
          <input type="url" name="trail[trail_points_attributes][${index}][map_link]" required>
        </div>
      </div>
    `;
    container.insertAdjacentHTML('beforeend', newPointHTML);
  });
});