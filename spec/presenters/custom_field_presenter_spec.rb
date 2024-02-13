require 'rails_helper'

RSpec.describe CustomFieldPresenter, type: :presenter do
  let(:document) { instance_double(SolrDocument) }
  let(:field_config) { Blacklight::Configuration::Field.new(field: field) }
  let(:view_context) { double('View context') }
  let(:options) { {} }
  let(:presenter) { described_class.new(view_context, document, field_config, options) }

  before do
    allow(document).to receive(:fetch).with(field_config.field, anything).and_return(values)
  end

  describe '#render' do
   
    # tests for the field 'spotlight_upload_description_tesim'
    context 'when field is spotlight_upload_description_tesim' do
      let(:field) { 'spotlight_upload_description_tesim' }

      context 'when value is a Markdown link' do
        let(:values) { ["Here is my sample description. [Google](https://www.google.com)"] }

        it 'renders a Markdown link as HTML link' do
          expected_output = "Here is my sample description. <a href=\"https://www.google.com\">Google</a>"
          allow(view_context).to receive(:raw).with(expected_output).and_return(expected_output)
          expect(presenter.render).to eq(expected_output)
        end
      end
      
      context 'when value is a Markdown link with HTML' do
        let(:values) { ["Here is my sample description. [Google](https://www.google.com) <b>bold</b>"] }  
       
        it 'renders a Markdown link as HTML link and escapes the HTML string' do
          expected_output = "Here is my sample description. <a href=\"https://www.google.com\">Google</a> &lt;b&gt;bold&lt;/b&gt;"
          allow(view_context).to receive(:raw).with(expected_output).and_return(expected_output)
          expect(presenter.render).to eq(expected_output)
        end
      end

      context 'when value has both incomplete markdown and correct markdown' do
        let(:values) { ["Here is my [sample] description. Learn about [the process](http://www.google.com)"] } 
       
        it 'does renders the correct link and ignores the incorrect markdown' do
          expected_output = "Here is my [sample] description. Learn about <a href=\"http://www.google.com\">the process</a>"
          allow(view_context).to receive(:raw).with(expected_output).and_return(expected_output)
          expect(presenter.render).to eq(expected_output)
        end
      end

      context 'when value contains HTML' do
        let(:values) { ["<b>bold</b>"] }

        it 'escapes the HTML string' do
          expected_output = "&lt;b&gt;bold&lt;/b&gt;"
          allow(view_context).to receive(:raw).with(expected_output).and_return(expected_output)
          expect(presenter.render).to eq(expected_output)
        end
      end

      context 'when value contains a URL not in markdown' do
        let(:values) { ['Click here(https://www.google.com)'] }
      
        it 'does not render a link' do
          expected_output = 'Click here(https://www.google.com)'
          allow(view_context).to receive(:raw).with(expected_output).and_return(expected_output)
          expect(presenter.render).to eq(expected_output)
        end
      end
    end

    # tests for all other fields
    context 'when field is not spotlight_upload_description_tesim' do
      let(:field) { 'spotlight_upload_category' }
      let(:values) { ['<b>bold</b>'] }
      
      it 'calls super and does not render html' do
        allow_any_instance_of(Blacklight::FieldPresenter).to receive(:render).and_call_original
        expect(presenter.render).to eq('&lt;b&gt;bold&lt;/b&gt;')
      end
    end

  end
end