# typed: false

require "rails_helper"

RSpec.describe Storage::StoreText do
  let(:command) { described_class.new(text: text) }
  let(:text) { "some_text" }
  let(:storage_service) { Storage::LocalService.new }

  before do
    allow(Rails).to receive(:env).and_return("development")
    allow(Rails.logger).to receive(:info)
    allow(Storage::LocalService).to receive(:new).and_return(storage_service)
    allow(storage_service).to receive(:store_text).and_return("path/to/stored/text.txt")
  end

  describe '#execute' do
    def perform
      command.run
    end

    it 'stores the text in the storage' do
      perform

      expect(Rails.logger).to have_received(:info).with("Storing text")
      expect(storage_service).to have_received(:store_text).with("some_text")
    end

    it 'returns the path of the stored text' do
      result = perform
      expect(result).to eq("path/to/stored/text.txt")
    end
  end
end
