# typed: ignore

require 'rails_helper'

RSpec.describe Storage::LocalService do
  let(:service) { described_class.new }
  let(:image) { 'some_image_binary' }
  let(:path) { 'some_path/' }

  before do
    stub_const('Storage::LocalService::BASE_FOLDER', 'cool_folder')
    stub_const('Storage::LocalService::IMAGE_FOLDER', 'cool_image_folder')
  end

  describe 'constants' do
    it 'has the correct folders' do
      expect(Storage::LocalService::BASE_FOLDER).to eq('cool_folder')
      expect(Storage::LocalService::IMAGE_FOLDER).to eq('cool_image_folder')
    end
  end

  describe '#store_image' do
    let(:mock_file) { instance_double(File) }
    let(:expected_path) { Rails.root.join('cool_folder', 'cool_image_folder', 'some_path/20250101_120000_000.png') }
    
    before do
      travel_to Time.zone.local(2025, 1, 1, 12, 0, 0)
  
      allow(FileUtils).to receive(:mkdir_p)
      
      allow(File).to receive(:open).and_yield(mock_file)
      allow(mock_file).to receive(:write)
    end

    it 'stores the image in the correct location' do
      service.store_image(image, path)
      
      expect(FileUtils).to have_received(:mkdir_p).with(File.dirname(expected_path))
      expect(File).to have_received(:open).with(expected_path, "wb")
      expect(mock_file).to have_received(:write).with(image)
    end
  end
end