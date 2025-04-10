// This script is used to stop a static carousel slideshow from preventing a link description from being clickable
$(document).ready(function() {
  $('.carousel-indicators .list-group-item p a').on('click', function(event) {
    event.stopPropagation();
  });
});
