document.addEventListener("DOMContentLoaded", function () {
  const loopContent = document.querySelector(".W_loopContent");
  const trails = loopContent.querySelectorAll(".O_trailInf");

  const duplicateTrails = [...trails].map((trail) => trail.cloneNode(true));
  duplicateTrails.forEach((duplicate) => loopContent.appendChild(duplicate));

  const totalWidth = trails.length * 2 * 220;
  loopContent.style.width = `${totalWidth}px`;
});