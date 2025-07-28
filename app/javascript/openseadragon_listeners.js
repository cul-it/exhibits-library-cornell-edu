// Sets up custom event listener before openseadragon-rails listeners

(function() {
  // Remove the openseadragon-container element if it exists
  // Ensures back button properly loads OSD viewer
  function removeOpenSeadragon() {
    const pictures = document.querySelectorAll('picture[data-openseadragon]:has(.openseadragon-container)');
    pictures.forEach(function(picture) {
      const existingContainer = picture.querySelector('div.openseadragon-container');
      if (existingContainer) {
        existingContainer.remove();
      }
    });
  }

  if (typeof Turbo !== 'undefined') {
    addEventListener("turbo:load", () => removeOpenSeadragon())
    addEventListener("turbo:frame-load", () => removeOpenSeadragon())
  } else {
    addEventListener('load', () => removeOpenSeadragon())
  }
})();
