document.addEventListener('DOMContentLoaded', function () {
  const addPointBtn = document.getElementById('add-trail-point');
  const pointsList = document.getElementById('trail-points-list');
  if (!addPointBtn || !pointsList) return;

  addPointBtn.addEventListener('click', function () {
    const currentPoints = pointsList.querySelectorAll('.point-card');
    const currentCount = currentPoints.length;

    if (currentCount >= 6) {
      alert('Максимум 6 точек');
      return;
    }

    // Генерируем следующий номер точки
    const nextNumber = currentCount + 1;
    const formattedNumber = String(nextNumber).padStart(2, '0');

    // Создаём элемент с правильной нумерацией
    const newPointCard = document.createElement('div');
    newPointCard.classList.add('point-card');

    newPointCard.innerHTML = `
      <span class="point-number">(0${formattedNumber})</span>
      <div class="point-photo-upload">
        <span class="upload-icon">↓</span>
        <input type="file" name="trail[trail_points_attributes][${currentCount}][image_url]" class="point-photo-input">
        <span class="photo-label">★ фото точки</span>
      </div>
      <div class="point-fields">
        <label>★ название точки</label>
        <input type="text" name="trail[trail_points_attributes][${currentCount}][name]" maxlength="56" placeholder="название точки">
        <span class="char-count">0 / 56</span>

        <label>★ описание точки</label>
        <textarea name="trail[trail_points_attributes][${currentCount}][description]" maxlength="100" placeholder="описание точки"></textarea>
        <span class="char-count">0 / 100</span>

        <label>★ ссылка на локацию точки</label>
        <input type="url" name="trail[trail_points_attributes][${currentCount}][map_link]" placeholder="ссылка на локацию точки">
      </div>
    `;

    pointsList.appendChild(newPointCard);
  });

  pointsList.addEventListener("click", function(e) {
    if (e.target.classList.contains("remove-trail-point")) {
      e.target.closest(".point-card").remove();
    }
  });
});