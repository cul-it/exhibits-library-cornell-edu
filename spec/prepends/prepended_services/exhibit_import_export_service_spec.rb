require 'rails_helper'

describe Spotlight::ExhibitImportExportService do
  let(:exported_exhibit) { create(:exhibit, title: 'Exported Exhibit') }
  let(:import_exhibit) { create(:exhibit, title: 'Import Exhibit') }
  let(:resource_data) do
    {
      'full_title_tesim' => 'My item title',
      'spotlight_upload_description_tesim' => '',
      'spotlight_upload_attribution_tesim' => '',
      'spotlight_upload_date_tesim' => '',
      'spotlight_copyright_tesim' => '',
      'spotlight_physicallocation_tesim' => ''
    }
  end
  let!(:upload) { create(:upload, exhibit: exported_exhibit) }
  let!(:multi_upload) do
    create(:upload_with_multiple_images,
           data: upload.data.merge('full_title_tesim' => 'Item with multiple uploads'),
           exhibit: exported_exhibit)
  end

  describe '#from_hash!' do
    let(:exhibit_export_json) { described_class.new(exported_exhibit).as_json }

    it 'updates exhibit with exported resource uploads' do
      expect(import_exhibit.resources.count).to eq(0)
      described_class.new(import_exhibit).from_hash!(exhibit_export_json)

      # Verify imported exhibit items
      expect(import_exhibit.resources.count).to eq(2)

      # Verify imported image uploads
      imported_item_with_multiple_images = import_exhibit.resources.find_by('data like ?', "%Item with multiple uploads%")
      expect(imported_item_with_multiple_images.uploads.count).to eq(2)

      # Verify imported exhibit title
      expect(import_exhibit.title).to eq('Exported Exhibit')
    end
  end
end
