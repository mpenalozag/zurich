# typed: false

require "rails_helper"

RSpec.describe Storage::StoreImage do
  let(:command) { described_class.new(image_data: image_data, path: path, data_type: data_type) }
  let(:image_data) { "b64_image" }
  let(:path) { "characters/" }
  let(:data_type) { "base64" }
  let(:storage_service) { Storage::LocalService.new }

  before do
    allow(Rails).to receive(:env).and_return("development")
    allow(Rails.logger).to receive(:info)
    allow(Base64).to receive(:decode64).and_return("decoded_binary_data")
    allow(Storage::LocalService).to receive(:new).and_return(storage_service)
    allow(storage_service).to receive(:store_image).and_return("path/to/stored/image.jpg")
  end

  describe '#execute' do
    def perform
      command.run
    end

    context 'when the data type is not base64' do
      let(:data_type) { "not_base64" }

      it 'raises an error' do
        expect { perform }.to raise_error(StandardError, "Data type not_base64 not supported")
      end
    end

    context 'when the data type is base64' do
      let(:data_type) { "base64" }

      it 'stores the image in the storage' do
        perform

        expect(Rails.logger).to have_received(:info).with("Storing image")
        expect(Base64).to have_received(:decode64).with("b64_image")
        expect(storage_service).to have_received(:store_image).with("decoded_binary_data", "characters/")
      end

      it 'returns the path of the stored image' do
        result = perform
        expect(result).to eq("path/to/stored/image.jpg")
      end
    end
  end
end
