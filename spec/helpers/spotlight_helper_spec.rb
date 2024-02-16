require 'rails_helper'

# in the SpotlightHelper test the module for the render_markdown_links method
# which is used to render the markdown links as HTML links LP-481

RSpec.describe SpotlightHelper, type: :helper do
  describe '#render_markdown_links' do
    context 'when the value is a Markdown link' do
      let(:options) { { value: ['Here is my sample description. [Google](https://www.google.com)'] } }

      it 'renders a Markdown link as HTML link' do
        result = helper.render_markdown_links(options)
        expect(result).to eq('Here is my sample description. <a href="https://www.google.com">Google</a>')
      end
    end
å
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
end