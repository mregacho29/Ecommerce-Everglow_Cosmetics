//= require rails-ujs

document.addEventListener('DOMContentLoaded', () => {
  // Search bar toggle functionality
  const searchToggle = document.getElementById('searchToggle');
  const searchBarRow = document.getElementById('searchBarRow');
  const searchClose = document.getElementById('searchClose');

  if (searchToggle && searchBarRow && searchClose) {
    // Show the search bar
    searchToggle.addEventListener('click', () => {
      searchBarRow.classList.add('show');
      searchBarRow.classList.remove('d-none');
    });

    // Hide the search bar
    searchClose.addEventListener('click', (e) => {
      e.preventDefault();
      searchBarRow.classList.remove('show');
      setTimeout(() => {
        searchBarRow.classList.add('d-none');
      }, 300); // Match the CSS transition duration
    });
  }

  // Scroll left functionality
  window.scrollLeft = function (containerId) {
    const container = document.getElementById(containerId);
    if (container) {
      container.scrollBy({ left: -300, behavior: 'smooth' });
    }
  };

  // Scroll right functionality
  window.scrollRight = function (containerId) {
    const container = document.getElementById(containerId);
    if (container) {
      container.scrollBy({ left: 300, behavior: 'smooth' });
    }
  };
});