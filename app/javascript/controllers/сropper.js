import Cropper from 'cropperjs';

document.addEventListener('DOMContentLoaded', () => {
  const input = document.getElementById('avatar-input');
  const preview = document.getElementById('preview');
  let cropper;

  input.addEventListener('change', (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();
      reader.onload = (e) => {
        preview.src = e.target.result;
        preview.style.display = 'block';

        if (cropper) {
          cropper.destroy();
        }

        cropper = new Cropper(preview, {
          aspectRatio: 1, // Соотношение сторон 1:1
          viewMode: 1,    // Ограничить кадрирование внутри изображения
          cropBoxResizable: false,
        });
      };
      reader.readAsDataURL(file);
    }
  });

  document.getElementById('upload-form').addEventListener('submit', (event) => {
    event.preventDefault();

    if (cropper) {
      const canvas = cropper.getCroppedCanvas({
        width: 200, // Желаемая ширина
        height: 200, // Желаемая высота
      });

      canvas.toBlob((blob) => {
        const formData = new FormData();
        formData.append('user[avatar]', blob, 'avatar.jpg');

        fetch('/users/update_avatar', {
          method: 'POST',
          body: formData,
        })
          .then((response) => response.json())
          .then((data) => {
            console.log(data);
          });
      });
    }
  });
});