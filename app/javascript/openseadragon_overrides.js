// Overrides openseadragon-rails.js to display current page for multi-image items

(function() {
  // Original function
  const originalOpenseadragon = HTMLCollection.prototype.openseadragon;

  const overriddenOpenseadragon = function() {
    // Remove the openseadragon-container element if it exists
    this.forEach(function(picture) {
      const existingContainer = picture.querySelector('div.openseadragon-container');
      if (existingContainer) {
        console.log('removing openseadragon-container');
        existingContainer.remove();
      }
    });

    // Call original function
    originalOpenseadragon.call(this);

    this.forEach(function(picture) {
      // Add handler for displaying current image number when cycling through images in multi-image item
      picture.osdViewer.addHandler('page', function (data) {
        $(picture).siblings().find('[id*="currentpage"]')[0].innerHTML = ( data.page + 1 );
      });
    });

    return this;
  };

  // Attach the function to NodeList and HTMLElement prototypes for convenience
  NodeList.prototype.openseadragon = overriddenOpenseadragon;
  HTMLCollection.prototype.openseadragon = overriddenOpenseadragon;

  // For a single HTMLElement
  HTMLElement.prototype.openseadragon = function() {
    return overriddenOpenseadragon.call([this]);
  };
  console.log('HELLO HELLO!!');

  function initOpenSeadragonAgain() {
    document.querySelectorAll('picture[data-openseadragon]:has(.openseadragon-container)').openseadragon();
  }

  if (typeof Turbo !== 'undefined') {
    addEventListener("turbo:load", () => initOpenSeadragonAgain())
    addEventListener("turbo:frame-load", () => initOpenSeadragonAgain())
  } else {
    addEventListener('load', () => initOpenSeadragonAgain())
  }


})();
