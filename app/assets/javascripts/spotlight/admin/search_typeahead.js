// Overrides addImageSelector function from https://github.com/projectblacklight/spotlight/blob/v3.5.0.4/app/assets/javascripts/spotlight/admin/search_typeahead.js
// Uses tilesource for multi-image selector instead of image id to handle uploaded images

function addImageSelector(input, panel, manifestUrl, initialize) {
  if (!manifestUrl) {
    showNonIiifAlert(input);
    return;
  }
  var cropper = input.data('iiifCropper');
  $.ajax(manifestUrl).done(
    function(manifest) {
      var Iiif = spotlightAdminIiif;
      var iiifManifest = new Iiif(manifestUrl, manifest);

      var thumbs = iiifManifest.imagesArray();

      hideNonIiifAlert(input);

      if (initialize) {
        cropper.setIiifFields(thumbs[0]);
        panel.multiImageSelector(); // Clears out existing selector
      }

      // BEGIN CUSTOMIZATION
      if(thumbs.length > 1) {
        panel.show();
        panel.multiImageSelector(thumbs, function(selectorImage) {
          cropper.setIiifFields(selectorImage);
        }, cropper.iiifUrlField.val());
      }
      // END CUSTOMIZATION
    }
  );
}
