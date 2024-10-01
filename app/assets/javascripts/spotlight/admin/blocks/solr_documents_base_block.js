// Replaces _itemPanel from https://github.com/projectblacklight/spotlight/blob/v3.5.0.2/app/assets/javascripts/spotlight/admin/blocks/resources_block.js
//   Adds optional "Alt text" input for resource image display
// Replaces afterPanelRender from https://github.com/projectblacklight/spotlight/blob/v3.5.0.4/app/assets/javascripts/spotlight/admin/blocks/solr_documents_base_block.js
//   Passes iiif tilesource to multiImageSelector instead of imageid

SirTrevor.Blocks.SolrDocumentsBase = (function(){

  return SirTrevor.Blocks.SolrDocumentsBase.extend({

    _itemPanel: function(data) {
      var index = "item_" + this.globalIndex++;
      var checked;
      if (data.display == "true") {
        checked = "checked='checked'"
      } else {
        checked = "";
      }
      var resource_id = data.slug || data.id;

      var altTextMarkup = '';
      if (['solr_documents', 'solr_documents_grid', 'solr_documents_carousel', 'solr_documents_features'].includes(this.type)) {
        altTextMarkup = [
          '<div class="field row mr-3">',
            '<label for="' + this.formId('alt_' + data.id) + '" class="col-form-label col-md-3"><%= i18n.t("blocks:resources:panel:alt") %></label>',
            '<input type="text" class="form-control col" id="' + this.formId('alt_' + data.id) + '" name="item[' + index + '][alt]" data-field="alt"/>',
          '</div>'
        ].join("\n");
      }
      var markup = [
          '<li class="field form-inline dd-item dd3-item" data-resource-id="' + resource_id + '" data-id="' + index + '" id="' + this.formId("item_" + data.id) + '">',
            '<input type="hidden" name="item[' + index + '][id]" value="' + resource_id + '" />',
            '<input type="hidden" name="item[' + index + '][title]" value="' + data.title + '" />',
            this._itemPanelIiifFields(index, data),
            '<input data-property="weight" type="hidden" name="item[' + index + '][weight]" value="' + data.weight + '" />',
              '<div class="card d-flex dd3-content">',
                '<div class="dd-handle dd3-handle"><%= i18n.t("blocks:resources:panel:drag") %></div>',
                '<div class="card-header item-grid">',
                  '<div class="d-flex">',
                    '<div class="checkbox">',
                      '<input name="item[' + index + '][display]" type="hidden" value="false" />',
                      '<input name="item[' + index + '][display]" id="'+ this.formId(this.display_checkbox + '_' + data.id) + '" type="checkbox" ' + checked + ' class="item-grid-checkbox" value="true"  />',
                      '<label class="sr-only" for="'+ this.formId(this.display_checkbox + '_' + data.id) +'"><%= i18n.t("blocks:resources:panel:display") %></label>',
                    '</div>',
                    '<div class="pic">',
                      '<img class="img-thumbnail" src="' + (data.thumbnail_image_url || ((data.iiif_tilesource || "").replace("/info.json", "/full/!100,100/0/default.jpg"))) + '" />',
                    '</div>',

                    '<div class="main form-horizontal">',
                      '<div class="title card-title">' + data.title + '</div>',
                      '<div>' + (data.slug || data.id) + '</div>',
                      altTextMarkup,
                    '</div>',

                    '<div class="remove float-right">',
                      '<a data-item-grid-panel-remove="true" href="#"><%= i18n.t("blocks:resources:panel:remove") %></a>',
                    '</div>',
                  '</div>',
                  '<div data-panel-image-pagination="true"></div>',
                '</div>',
              '</div>',
            '</li>'
      ].join("\n");

      var panel = $(_.template(markup)(this));
      panel.find('[data-field="alt"]').val(data.alt);
      var context = this;

      $('.remove a', panel).on('click', function(e) {
        e.preventDefault();
        $(this).closest('.field').remove();
        context.afterPanelDelete();

      });

      this.afterPanelRender(data, panel);

      return panel;
    },
    afterPanelRender: function(data, panel) {
      var context = this;
      var manifestUrl = data.iiif_manifest || data.iiif_manifest_url;

      if (!manifestUrl) {
        $(panel).find('[name$="[thumbnail_image_url]"]').val(data.thumbnail_image_url || data.thumbnail);
        $(panel).find('[name$="[full_image_url]"]').val(data.full_image_url);

        return;
      }

      $.ajax(manifestUrl).done(
        function(manifest) {
          var Iiif = spotlightAdminIiif;
          var iiifManifest = new Iiif(manifestUrl, manifest);

          var thumbs = iiifManifest.imagesArray();

          // BEGIN CUSTOMIZATION
          if (!data.iiif_tilesource) {
            context.setIiifFields(panel, thumbs[0], !!data.iiif_manifest_url);
          }
          
          if(thumbs.length > 1) {
            panel.multiImageSelector(thumbs, function(selectorImage) {
              context.setIiifFields(panel, selectorImage, false);
            }, data.iiif_tilesource);
          }
          // END CUSTOMIZATION
        }
      );
    }

  });

})();
