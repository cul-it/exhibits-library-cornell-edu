require 'rails_helper'

# Tests overrides in PrependedControllers::CsvUploadController
describe Spotlight::Resources::CsvUploadController, type: :controller do
  routes { Spotlight::Engine.routes }
  let(:exhibit) { create(:exhibit) }
  let(:user) { create(:user) }
  let(:valid_csv) do
    "url,full_title_tesim,spotlight_upload_description_tesim,spotlight_upload_attribution_tesim," \
    "spotlight_upload_date_tesim,spotlight_copyright_tesim\n" \
    "s3.bucket/image1.jpg,Item Title,Item Description,Jane Doe,Aug 2024,2000"
  end

  let(:malformed_csv) do
    "url,full_title_tesim,spotlight_upload_description_tesim,spotlight_upload_attribution_tesim," \
    "s3.bucket/image1.jpg,\"Item Title,Item Description\n" \
    "s3.bucket/image2.jpg,Item Title,Item Description"
  end

  let(:invalid_csv_headers) do
    "url,woops,spotlight_upload_description_tesim,spotlight_upload_attribution_tesim," \
    "spotlight_upload_date_tesim,spotlight_copyright_tesim\n" \
    "s3.bucket/image1.jpg,Item Title,Item Description,Jane Doe,Aug 2024,2000"
  end

  before do
    allow(controller).to receive(:current_exhibit).and_return(exhibit)
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:csv_io_name).and_return("test.csv")
    sign_in user

    # Stub the authorization check
    allow(controller).to receive(:authorize!).and_return(true)
  end

  describe "POST create" do
    context "when valid csv file is used" do
      before do
        allow(controller).to receive(:csv_io_param).and_return(valid_csv)
      end

      it "shows the success flash message" do
        post :create, params: { exhibit_id: exhibit.id }
        expect(flash[:notice]).to eq(I18n.t('spotlight.resources.upload.csv.success', file_name: "test.csv"))
      end
    end

    context "when malformed csv file is used" do
      before do
        allow(controller).to receive(:csv_io_param).and_return(malformed_csv)
      end

      it "shows the malformed error flash message" do
        post :create, params: { exhibit_id: exhibit.id }
        expect(flash[:error]).to eq(I18n.t('spotlight.resources.upload.malformed_non_UTF8_csv_data'))
      end
    end

    context "when invalid csv headers are used" do
      before do
        allow(controller).to receive(:csv_io_param).and_return(invalid_csv_headers)
      end

      it "shows the invalid csv headers error flash message" do
        post :create, params: { exhibit_id: exhibit.id }
        expect(flash[:error]).to eq(I18n.t('spotlight.resources.upload.invalid_csv_headers'))
      end
    end
  end
end
