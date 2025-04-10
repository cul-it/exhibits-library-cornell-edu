// Overrides openseadragon-rails.js to display current page for multi-image items

(function() {
  // Original function
  const originalOpenseadragon = HTMLCollection.prototype.openseadragon;

  const overriddenOpenseadragon = function() {
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

})();
