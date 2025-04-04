// Replaces _itemPanel from https://github.com/projectblacklight/spotlight/blob/v4.0.3/app/javascript/spotlight/admin/blocks/resources_block.js
//   Adds optional "Alt text" input for resource image display

solrDocumentBlockItemPanel = function(data) {
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
    altTextMarkup = `
      <div class="field row mr-3">
        <label for="${this.formId('alt_' + data.id)}" class="col-form-label col-md-3">${i18n.t("blocks:resources:panel:alt")}</label>
        <input type="text" class="form-control col" id="${this.formId('alt_' + data.id)}" name="item[${index}][alt]" data-field="alt"/>
      </div>
    `
  }
  var markup = `
      <li class="field form-inline dd-item dd3-item" data-resource-id="${resource_id}" data-id="${index}" id="${this.formId("item_" + data.id)}">
        <input type="hidden" name="item[${index}][id]" value="${resource_id}" />
        <input type="hidden" name="item[${index}][title]" value="${data.title}" />
        ${this._itemPanelIiifFields(index, data)}
        <input data-property="weight" type="hidden" name="item[${index}][weight]" value="${data.weight}" />
          <div class="card d-flex dd3-content">
            <div class="dd-handle dd3-handle">${i18n.t("blocks:resources:panel:drag")}</div>
            <div class="card-header item-grid">
              <div class="d-flex">
                <div class="checkbox">
                  <input name="item[${index}][display]" type="hidden" value="false" />
                  <input name="item[${index}][display]" id="${this.formId(this.display_checkbox + '_' + data.id)}" type="checkbox" ${checked} class="item-grid-checkbox" value="true"  />
                  <label class="sr-only visually-hidden" for="${this.formId(this.display_checkbox + '_' + data.id)}">${i18n.t("blocks:resources:panel:display")}</label>
                </div>
                <div class="pic">
                  <img class="img-thumbnail" src="${(data.thumbnail_image_url || ((data.iiif_tilesource || "").replace("/info.json", "/full/!100,100/0/default.jpg")))}" />
                </div>
                <div class="main form-horizontal">
                  <div class="title card-title">${data.title}</div>
                  <div>${(data.slug || data.id)}</div>
                  ${altTextMarkup}
                </div>
                <div class="remove float-right float-end">
                  <a data-item-grid-panel-remove="true" href="#">${i18n.t("blocks:resources:panel:remove")}</a>
                </div>
              </div>
              <div data-panel-image-pagination="true"></div>
            </div>
          </div>
        </li>
  `

  const panel = $(markup);
  var context = this;

  $('.remove a', panel).on('click', function(e) {
    e.preventDefault();
    $(this).closest('.field').remove();
    context.afterPanelDelete();

  });

  this.afterPanelRender(data, panel);

  return panel;
};

// Item Row
SirTrevor.Blocks.SolrDocuments = (function(){
  return SirTrevor.Blocks.SolrDocuments.extend({
    _itemPanel: solrDocumentBlockItemPanel,
  });
})();

// Item Carousel
SirTrevor.Blocks.SolrDocumentsCarousel = (function(){
  return SirTrevor.Blocks.SolrDocumentsCarousel.extend({
    _itemPanel: solrDocumentBlockItemPanel,
  });
})();

// Item Slideshow
SirTrevor.Blocks.SolrDocumentsFeatures = (function(){
  return SirTrevor.Blocks.SolrDocumentsFeatures.extend({
    _itemPanel: solrDocumentBlockItemPanel,
  });
})();

// Item Grid
SirTrevor.Blocks.SolrDocumentsGrid = (function(){
  return SirTrevor.Blocks.SolrDocumentsGrid.extend({
    _itemPanel: solrDocumentBlockItemPanel,
  });
})();
