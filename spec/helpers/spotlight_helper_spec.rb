require 'rails_helper'

describe SpotlightHelper do
  # Used to render the markdown links as HTML links LP-481
  describe '#render_markdown_links' do
    context 'when the value is a Markdown link' do
      let(:options) { { value: ['Here is my sample description. [Google](https://www.google.com)'] } }

      it 'renders a Markdown link as HTML link' do
        result = helper.render_markdown_links(options)
        expect(result).to eq('Here is my sample description. <a href="https://www.google.com">Google</a>')
      end
    end

    context 'when the value is a Markdown link with HTML' do
      let(:options) { { value: ['Here is my sample description. [Google](https://www.google.com) <b>bold</b>'] } }

      it 'renders a markdown link as an HTML link and will escape the HTML' do
        result = helper.render_markdown_links(options)
        expect(result).to eq('Here is my sample description. <a href="https://www.google.com">Google</a> &lt;b&gt;bold&lt;/b&gt;')
      end
    end

    context 'when the value has both an incomplete markdown and correct markdown' do
      let(:options) { { value: ['Here is my [sample] description. Learn about [the process](http://www.google.com)'] } }

      it 'renders the correct link and ignores the incorrect markdown' do
        result = helper.render_markdown_links(options)
        expect(result).to eq('Here is my [sample] description. Learn about <a href="http://www.google.com">the process</a>')
      end
    end

    context 'when the value contains a URL that is not in markdown format' do
      let(:options) { { value: ['Click here(https://www.google.com)'] } }

      it 'does not render a link' do
        result = helper.render_markdown_links(options)
        expect(result).to eq('Click here(https://www.google.com)')
      end
    end

    context 'when the value is not given' do
      let(:options) { {} }

      it 'will return an empty string' do
        result = helper.render_markdown_links(options)
        expect(result).to eq('')
      end
    end
  end

  describe '#initial_page' do
    let(:solr_doc) do
      SolrDocument.new(
        content_metadata_image_iiif_info_ssm: [
          '/images/1-alphanumericgibberish/info.json',
          '/images/2-alphanumericgibberish/info.json'
        ]
      )
    end
    let(:block_options) { { iiif_tilesource: 'http://www.example.com/images/2-alphanumericgibberish/info.json' } }
    let(:config) { Spotlight::CatalogController.blacklight_config }

    before do
      without_partial_double_verification do
        allow(helper).to receive(:blacklight_config) { config }
      end
    end

    context 'when a tilesource is selected' do
      it 'returns the index of the selected image tile source' do
        expect(helper.initial_page(solr_doc, block_options)).to eq(1)
      end
    end

    context 'when block options with selected tilesource are not provided' do
      it 'returns 0' do
        expect(helper.initial_page(solr_doc, nil)).to eq(0)
      end
    end

    context 'when the tilesource from block options are not in the document' do
      it 'returns 0' do
        block_options = { iiif_tilesource: 'http://www.example.com/images/NOPE/info.json' }
        expect(helper.initial_page(solr_doc, block_options)).to eq(0)
      end
    end

    context 'when the tilesource from block options are in an unexpected format' do
      it 'returns 0' do
        block_options = { iiif_tilesource: 'boop' }
        expect(helper.initial_page(solr_doc, block_options)).to eq(0)
      end
    end
  end
end
