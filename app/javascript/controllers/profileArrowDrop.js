document.addEventListener("DOMContentLoaded", function () {
  const toggleButtons = document.querySelectorAll(".toggle-button");

  toggleButtons.forEach((button) => {
    button.addEventListener("click", function () {
      const targetId = this.getAttribute("aria-controls");
      const content = document.getElementById(targetId);

      // Toggle open class for animation
      content.classList.toggle("open");

      // Toggle display
      if (content.classList.contains("open")) {
        content.style.display = "block";
      } else {
        content.style.display = "none";
      }

      // Update button state
      const isExpanded = this.getAttribute("aria-expanded") === "true";
      this.setAttribute("aria-expanded", !isExpanded);

      // Rotate arrow
      const arrow = this.querySelector(".arrow");
      arrow.classList.toggle("rotated");
    });
  });
});