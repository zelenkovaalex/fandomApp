$(document).ready(function() {
  // Initialize active filter
  $('.filter-group a').on('click', function(e) {
    e.preventDefault();

    // Remove 'active' class from all filters
    $('.filter-group a').removeClass('active');

    // Add 'active' class to the clicked filter
    $(this).addClass('active');

    // Get the filter value
    const filterValue = $(this).data('filter'); // Use .data() instead of .attr() for better handling

    // Send AJAX request to get filtered profiles
    $.ajax({
      url: '/profiles/filter',
      method: 'GET',
      data: { filter: filterValue },
      success: function(data) {
        $('#profiles-container').html(data);
      },
      error: function(xhr, status, error) {
        console.error("Error fetching filtered profiles:", error);
      }
    });
  });


  var toggleButton = document.querySelector('.toggle-button[aria-controls="fandoms-list"]');
    var fandomsList = document.getElementById('fandoms-list');
    if (toggleButton && fandomsList) {
      toggleButton.addEventListener('click', function() {
        var expanded = toggleButton.getAttribute('aria-expanded') === 'true';
        toggleButton.setAttribute('aria-expanded', !expanded);
        fandomsList.style.display = expanded ? 'none' : 'block';
        toggleButton.querySelector('.arrow').textContent = expanded ? '▼' : '▲';
      });
    }
});