SirTrevor.Locales.en.blocks = $.extend(SirTrevor.Locales.en.blocks, {
  // Override the uploaded_items widget description
  uploaded_items: {
    title: "Uploaded Item Row",
    description: "This widget displays uploaded items in a horizontal row. Each item should be less than 10MB in size. Optionally, you can add a heading and/or text to be displayed adjacent to the items. The item caption and link URL fields are also optional.",
    caption: 'Caption',
    link: 'Link URL'
  },
});

// Spotlight v4 adds a new alt text field to the SolrDocuments block. Don't lose the old alt text field.
// TODO: Remove this override when we've migrated all old alt text fields to the new alt text fields.
const altTextData = function(data) {
  const isDecorative = data.decorative;
  const oldAltText = data.alt || '';
  const altText = isDecorative ? '' : (data.alt_text || '');
  const altTextBackup = data.alt_text_backup || '';
  const placeholderAttr = isDecorative ? '' : `placeholder="${i18n.t("blocks:resources:alt_text:placeholder")}"`;
  const disabledAttr = isDecorative ? 'disabled' : '';

  return { isDecorative, oldAltText, altText, altTextBackup, placeholderAttr, disabledAttr };
};

const altTextHTML = function(index, data) {
  const { isDecorative, oldAltText, altText, altTextBackup, placeholderAttr, disabledAttr } = this._altTextData(data);
  const newAltText = altText || oldAltText;
  return `<div class="mt-2 pt-2 d-flex">
      <div class="me-2">
        <label class="col-form-label pb-0 pt-1" for="${this.formId(this.alt_text_textarea + '_' + data.id)}">${i18n.t("blocks:resources:alt_text:alternative_text")}</label>
        <div class="form-check mb-1 justify-content-end">
          <input class="form-check-input" type="checkbox"
            id="${this.formId(this.decorative_checkbox + '_' + data.id)}" name="item[${index}][decorative]" ${isDecorative ? 'checked' : ''}>
          <label class="form-check-label" for="${this.formId(this.decorative_checkbox + '_' + data.id)}">${i18n.t("blocks:resources:alt_text:decorative")}</label>
        </div>
      </div>
      <div class="flex-grow-1 flex-fill d-flex">
        <input type="hidden" name="item[${index}][alt]" value="${oldAltText}" />
        <input type="hidden" name="item[${index}][alt_text_backup]" value="${altTextBackup}" />
        <textarea class="form-control w-100" rows="2" ${placeholderAttr}
          id="${this.formId(this.alt_text_textarea + '_' + data.id)}" name="item[${index}][alt_text]" ${disabledAttr}>${newAltText}</textarea>
      </div>
    </div>`
};

// Item Row
SirTrevor.Blocks.SolrDocuments = (function(){
  return SirTrevor.Blocks.SolrDocuments.extend({
    _altTextData: altTextData,
    altTextHTML: altTextHTML,
  });
})();

// Item Carousel
SirTrevor.Blocks.SolrDocumentsCarousel = (function(){
  return SirTrevor.Blocks.SolrDocumentsCarousel.extend({
    _altTextData: altTextData,
    altTextHTML: altTextHTML,
  });
})();

// Item Slideshow
SirTrevor.Blocks.SolrDocumentsFeatures = (function(){
  return SirTrevor.Blocks.SolrDocumentsFeatures.extend({
    _altTextData: altTextData,
    altTextHTML: altTextHTML,
  });
})();

// Item Grid
SirTrevor.Blocks.SolrDocumentsGrid = (function(){
  return SirTrevor.Blocks.SolrDocumentsGrid.extend({
    _altTextData: altTextData,
    altTextHTML: altTextHTML,
  });
})();
